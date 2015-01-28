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
   
    class func getSchedule(group : GroupsEntity, dateStart: NSDate, dateEnd: NSDate, completionHandler: ((Array<LessonScheduleEntity>?, NSError?) -> Void)!) {
        
        getSchedule(group, dateStart: dateStart, dateEnd: dateEnd, useCache: true, completionHandler: completionHandler)
    }
    
    class func getSchedule(group : GroupsEntity, dateStart: NSDate, dateEnd: NSDate, useCache: Bool, completionHandler: ((Array<LessonScheduleEntity>?, NSError?) -> Void)!) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let userDefaultsGroupKey = "ScheduleKey \(group.id).\(dateStart)"
        let date = userDefaults.objectForKey(userDefaultsGroupKey) as NSDate?
        let expiryDate = date?.dateByAddingTimeInterval(ScheduleCacheTimeInterval)
        
        if (useCache == false || expiryDate == nil || expiryDate!.compare(NSDate()) == .OrderedAscending ) {
            featchSchedule(group, dateStart: dateStart, dateEnd: dateEnd, { (items: Array<LessonScheduleEntity>?, error: NSError?) -> Void in
                if (error == nil) {
                    userDefaults.setObject(NSDate(), forKey: userDefaultsGroupKey)
                    userDefaults.synchronize()
                    completionHandler(items, error)
                } else {
                    self.featchScheduleFromCache(group, dateStart: dateStart, dateEnd: dateEnd, completionHandler: completionHandler)
                }
            })
        } else {
            featchScheduleFromCache(group, dateStart: dateStart, dateEnd: dateEnd, completionHandler: completionHandler)
        }
    }
    
    class func featchSchedule(group : GroupsEntity, dateStart: NSDate, dateEnd: NSDate, completionHandler: ((Array<LessonScheduleEntity>?, NSError?) -> Void)!) {
        
        let path = "/getGroupSchedule"
        
        let queryItems = "groupId=\(group.id)&dateStart=\(DateUtils.formatDate(dateStart, withFormat: DateFormatDayMonthYear2))&dateEnd=\(DateUtils.formatDate(dateEnd, withFormat: DateFormatDayMonthYear2))"
        
        resumeRequest(path, queryItems: queryItems, completionHandler: { (result: NSDictionary?, error: NSError?) -> Void in

            if (error == nil) {
                self.storeSchedule(group, dateStart: dateStart, dateEnd: dateEnd, result: result, completionHandler: completionHandler)
            } else {
                completionHandler(nil, error)
            }
        })
    }

    class func storeSchedule(group : GroupsEntity, dateStart: NSDate, dateEnd: NSDate, result: NSDictionary?, completionHandler: ((Array<LessonScheduleEntity>?, NSError?) -> Void)!) {
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        let cdHelper = delegate.cdh
        if let context = cdHelper.backgroundContext {
            context.performBlock({ () -> Void in
                
                let group_ = context.objectWithID(group.objectID) as GroupsEntity
                
                let request = NSFetchRequest(entityName: LessonScheduleEntityName)
                let predicate = NSPredicate(format: "(isTeacherSchedule == NO) && (ANY groups == %@) && (date >= %@) && (date <= %@)", group_, dateStart, dateEnd)
                request.predicate = predicate
                
                var error : NSError?
                let cacheItems = context.executeFetchRequest(request, error: &error) as [NSManagedObject]
                for item in cacheItems {
                    context.deleteObject(item)
                }
                
                var lessonSchedule : [LessonScheduleEntity] = Array()
                if let days = result?["days"] as? [NSDictionary] {
                    
                    for day in days {
                        let strDate = day["date"] as String
                        let date = DateUtils.dateFromString(strDate, format: DateFormatKeyDateInDefaultFormat)
                        
                        if let lessons = day["lessons"] as? [NSDictionary] {
                            
                            for lesson in lessons {
                                let room = lesson["room"] as String?
                                let timeStart = lesson["timeStart"] as String
                                let timeEnd = lesson["timeEnd"] as String
                                let teacher = lesson["teacher"] as NSDictionary
                                let subGroup = lesson["subgroup"] as NSDictionary?
                                
                                var newlesson = NSEntityDescription.insertNewObjectForEntityForName(LessonScheduleEntityName, inManagedObjectContext: context) as LessonScheduleEntity
                                newlesson.isTeacherSchedule = false
                                newlesson.groups = NSSet(object: group_)
                                newlesson.date = date
                                newlesson.studyName = lesson["title"] as? String ?? ""
                                newlesson.type = lesson["type"] as? String ?? ""
                                newlesson.address = lesson["address"] as? String ?? ""
                                newlesson.room = room ?? ""
                                newlesson.startTime = DateManager.timeIntervalWithTimeText(timeStart)
                                newlesson.stopTime = DateManager.timeIntervalWithTimeText(timeEnd)
                                if let subGroup = subGroup {
                                    newlesson.subgroupTitle = subGroup["title"] as? String
                                }
                                
                                if let teacherId = teacher["id"] as? String {
                                    var newTeacher = self.featchTeacher(teacherId, context:context)
                                    if (newTeacher == nil) {
                                        newTeacher = NSEntityDescription.insertNewObjectForEntityForName(TeacherInfoEntityName, inManagedObjectContext: context) as? TeacherInfoEntity
                                        newTeacher?.id = teacherId ?? ""
                                        newTeacher?.title = teacher["fullname"] as? String
                                        newTeacher?.post = teacher["post"] as? String
                                    }
                                    newlesson.teacher = newTeacher!
                                }
                                
                                lessonSchedule.append(newlesson)
                            }
                        }
                        
                    }
                    
                }

                cdHelper.saveContext(context)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(lessonSchedule, nil)
                })
            })
        } else {
            completionHandler(nil, NSError())
        }
    }
    
    class func featchScheduleFromCache(group : GroupsEntity, dateStart: NSDate, dateEnd: NSDate, completionHandler: ((Array<LessonScheduleEntity>?, NSError?) -> Void)!) {
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        let cdHelper = delegate.cdh
        if let context = cdHelper.backgroundContext {
            context.performBlock({ () -> Void in
                
                let request = NSFetchRequest(entityName: LessonScheduleEntityName)
                var sorter: NSSortDescriptor = NSSortDescriptor(key: "date" , ascending: true)
                var lessonSorter = NSSortDescriptor(key: "startTime" , ascending: true)

                let group_ = context.objectWithID(group.objectID) as GroupsEntity
                let predicate = NSPredicate(format: "(isTeacherSchedule == NO) && (ANY groups == %@) && (date >= %@) && (date <= %@)", group_, dateStart, dateEnd)
                
                request.resultType = .ManagedObjectIDResultType
                request.sortDescriptors = [sorter, lessonSorter]
                request.predicate = predicate
                
                var error : NSError?
                let itemIds = context.executeFetchRequest(request, error: &error) as [NSManagedObjectID]
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var items : [LessonScheduleEntity]?
                    if error == nil {
                        items = cdHelper.convertToMainQueue(itemIds) as? [LessonScheduleEntity]
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
    
    class func featchTeacher(id: String, context: NSManagedObjectContext) -> TeacherInfoEntity? {
        let request = NSFetchRequest(entityName: TeacherInfoEntityName)
        request.predicate = NSPredicate(format: "(id == %@)", id)
        
        var error : NSError?
        let cacheItems = context.executeFetchRequest(request, error: &error) as [TeacherInfoEntity]
        
        return cacheItems.first
    }
    
}
