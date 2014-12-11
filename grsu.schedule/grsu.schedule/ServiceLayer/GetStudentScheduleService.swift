//
//  GetStudentScheduleService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/23/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit
import CoreData

class GetStudentScheduleService: BaseDataService {
   
    class func getSchedule(group : GroupsEntity, dateStart: NSDate, dateEnd: NSDate, completionHandler: ((Array<StudentDayScheduleEntity>?, NSError?) -> Void)!) {
        
        getSchedule(group, dateStart: dateStart, dateEnd: dateEnd, useCache: true, completionHandler: completionHandler)
    }
    
    class func getSchedule(group : GroupsEntity, dateStart: NSDate, dateEnd: NSDate, useCache: Bool, completionHandler: ((Array<StudentDayScheduleEntity>?, NSError?) -> Void)!) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let userDefaultsGroupKey = "ScheduleKey \(group.id).\(dateStart)"
        let date = userDefaults.objectForKey(userDefaultsGroupKey) as NSDate?
        let expiryDate = date?.dateByAddingTimeInterval(ScheduleCacheTimeInterval)
        
        if (useCache == false || expiryDate == nil || expiryDate!.compare(NSDate()) == .OrderedAscending ) {
            featchSchedule(group.id, dateStart: dateStart, dateEnd: dateEnd, { (items: Array<StudentDaySchedule>?, error: NSError?) -> Void in
                if (items?.count > 0) {
                    self.storeSchedule(group, dateStart: dateStart, dateEnd: dateEnd, items: items!, completionHandler: { () -> Void in
                        userDefaults.setObject(NSDate(), forKey: userDefaultsGroupKey)
                        self.featchScheduleFromCache(group, dateStart: dateStart, dateEnd: dateEnd, completionHandler: completionHandler)
                    })
                } else {
                    self.featchScheduleFromCache(group, dateStart: dateStart, dateEnd: dateEnd, completionHandler: completionHandler)
                }
            })
        } else {
            featchScheduleFromCache(group, dateStart: dateStart, dateEnd: dateEnd, completionHandler: completionHandler)
        }
    }
    
    class func featchSchedule(groupId : String, dateStart: NSDate, dateEnd: NSDate, completionHandler: ((Array<StudentDaySchedule>?, NSError?) -> Void)!) {
        
        let path = "/getGroupSchedule"
        
        let queryItems = [
            NSURLQueryItem(name: "groupId", value: groupId),
            NSURLQueryItem(name: "dateStart", value: DateUtils.formatDate(dateStart, withFormat: DateFormatDayMonthYear2)),
            NSURLQueryItem(name: "dateEnd", value: DateUtils.formatDate(dateEnd, withFormat: DateFormatDayMonthYear2))
        ]
        
        resumeRequest(path, queryItems: queryItems, completionHandler: { (result: NSDictionary?, error: NSError?) -> Void in

            var res : [StudentDaySchedule] = Array()
            if let days = result?["days"] as? [NSDictionary] {
                
                for day in days {
                    
                    var scheduLelessons : [LessonSchedule] = Array()
                    if let lessons = day["lessons"] as? [NSDictionary] {
                        
                        for lesson in lessons {
                            let room = lesson["room"] as String?
                            let timeStart = lesson["timeStart"] as String
                            let timeEnd = lesson["timeEnd"] as String
                            let teacher = lesson["teacher"] as NSDictionary
                            
                            let teacherInfo = BaseTeacherInfo()
                            teacherInfo.id = teacher["id"] as? String
                            teacherInfo.title = teacher["title"] as? String
                            
                            let scheduLelesson = LessonSchedule()
                            scheduLelesson.studyName = lesson["title"] as? String
                            scheduLelesson.room = room != nil ? room!.toInt() : 0
                            scheduLelesson.address = lesson["address"] as? String
                            scheduLelesson.type = lesson["type"] as? String
                            scheduLelesson.startTime = self.timeIntervalWithTimeText(timeStart)
                            scheduLelesson.stopTime = self.timeIntervalWithTimeText(timeEnd)
                            scheduLelesson.teacher = teacherInfo
                            
                            scheduLelessons.append(scheduLelesson)
                        }
                    }
                    
                    let strDate = day["date"] as String
                    
                    let daySchedule = StudentDaySchedule()
                    daySchedule.date = DateUtils.dateFromString(strDate, format: DateFormatKeyDateInDefaultFormat)
                    daySchedule.lessons = scheduLelessons
                    
                    res.append(daySchedule)
                }
                
            }
            
            completionHandler(res, error)
        })
    }

    class func featchScheduleFromCache(group : GroupsEntity, dateStart: NSDate, dateEnd: NSDate, completionHandler: ((Array<StudentDayScheduleEntity>?, NSError?) -> Void)!) {
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        let cdHelper = delegate.cdh
        if let context = cdHelper.backgroundContext {
            context.performBlock({ () -> Void in
                
                let request = NSFetchRequest(entityName: StudentDayScheduleEntityName)
                var sorter: NSSortDescriptor = NSSortDescriptor(key: "date" , ascending: true)
                let predicate = NSPredicate(format: "(group == %@) && (date >= %@) && (date <= %@)", group, dateStart, dateEnd)
                
                request.resultType = .ManagedObjectIDResultType
                request.sortDescriptors = [sorter]
                request.predicate = predicate
                
                var error : NSError?
                let itemIds = context.executeFetchRequest(request, error: &error) as [NSManagedObjectID]
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var items : [StudentDayScheduleEntity]?
                    if error == nil {
                        items = cdHelper.convertToMainQueue(itemIds) as? [StudentDayScheduleEntity]
                    } else {
                        NSLog("executeFetchRequest error: %@", error!)
                    }
                    
                    completionHandler(items, error)
                })
            })
        } else {
            completionHandler(nil, NSError())
        }
        
    }
    
    class func storeSchedule(group : GroupsEntity, dateStart: NSDate, dateEnd: NSDate, items: Array<StudentDaySchedule>, completionHandler: ( () -> Void)!) {
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        let cdHelper = delegate.cdh
        if let context = cdHelper.backgroundContext {
            context.performBlock({ () -> Void in
                
                let group_ = context.objectWithID(group.objectID) as GroupsEntity

                let request = NSFetchRequest(entityName: StudentDayScheduleEntityName)
                let predicate = NSPredicate(format: "(group == %@) && (date >= %@) && (date <= %@)", group_, dateStart, dateEnd)
                request.predicate = predicate
                
                var error : NSError?
                let cacheItems = context.executeFetchRequest(request, error: &error) as [NSManagedObject]
                for item in cacheItems {
                    context.deleteObject(item)
                }
                
                var handledItems: [StudentDayScheduleEntity] = Array()
                for daySchedule in items {

                    var newItem = NSEntityDescription.insertNewObjectForEntityForName(StudentDayScheduleEntityName, inManagedObjectContext: context) as StudentDayScheduleEntity
                    newItem.date = daySchedule.date!
                    newItem.group = group_

                    for lessonSchedule in daySchedule.lessons! {
                        
                        var newlesson = NSEntityDescription.insertNewObjectForEntityForName(LessonScheduleEntityName, inManagedObjectContext: context) as LessonScheduleEntity
                        newlesson.studentDaySchedule = newItem
                        newlesson.studyName = lessonSchedule.studyName ?? ""
                        newlesson.type = lessonSchedule.type ?? ""
                        newlesson.address = lessonSchedule.address ?? ""
                        newlesson.room = lessonSchedule.room ?? 0
                        newlesson.startTime = lessonSchedule.startTime ?? 0
                        newlesson.stopTime = lessonSchedule.stopTime ?? 0
                        
                        if let teacher = lessonSchedule.teacher {
                            var newTeacher = self.featchTeacher(teacher.id!, context:context)
                            if (newTeacher == nil) {
                                newTeacher = NSEntityDescription.insertNewObjectForEntityForName(TeacherInfoEntityName, inManagedObjectContext: context) as? TeacherInfoEntity
                                newTeacher?.id = teacher.id!
                                newTeacher?.title = teacher.title!
                            }
                            newlesson.teacher = newTeacher!
                        }
                    }
                    
                    handledItems.append(newItem)
                }
                
                cdHelper.saveContext(context)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler()
                })
            })
        } else {
            completionHandler()
        }
    }
    
    class func featchTeacher(id: String, context: NSManagedObjectContext) -> TeacherInfoEntity? {
        let request = NSFetchRequest(entityName: TeacherInfoEntityName)
        request.predicate = NSPredicate(format: "(id == %@)", id)
        
        var error : NSError?
        let cacheItems = context.executeFetchRequest(request, error: &error) as [TeacherInfoEntity]
        
        return cacheItems.first
    }
    
    // MARK: - Utils
    
    class func timeIntervalWithTimeText(time: String) -> Int {
        let arr = time.componentsSeparatedByString(":")
        let h : Int = arr[0].toInt()!
        let m : Int = arr[1].toInt()!
        
        return h * 60 + m
    }
    
}
