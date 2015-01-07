//
//  GetTeacherScheduleService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 1/5/15.
//  Copyright (c) 2015 Ruslan Maslouski. All rights reserved.
//

import UIKit
import CoreData

class GetTeacherScheduleService: BaseDataService {

    class func getSchedule(teacher : TeacherInfoEntity, dateStart: NSDate, dateEnd: NSDate, completionHandler: ((Array<LessonScheduleEntity>?, NSError?) -> Void)!) {
        
        getSchedule(teacher, dateStart: dateStart, dateEnd: dateEnd, useCache: true, completionHandler: completionHandler)
    }
    
    class func getSchedule(teacher : TeacherInfoEntity, dateStart: NSDate, dateEnd: NSDate, useCache: Bool, completionHandler: ((Array<LessonScheduleEntity>?, NSError?) -> Void)!) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let userDefaultsScheduleTeacherKey = "ScheduleTeacherKey \(teacher.id).\(dateStart)"
        let date = userDefaults.objectForKey(userDefaultsScheduleTeacherKey) as NSDate?
        let expiryDate = date?.dateByAddingTimeInterval(ScheduleCacheTimeInterval)
        
        if (useCache == false || expiryDate == nil || expiryDate!.compare(NSDate()) == .OrderedAscending ) {
            featchSchedule(teacher, dateStart: dateStart, dateEnd: dateEnd, { (items: Array<LessonScheduleEntity>?, error: NSError?) -> Void in
                if (error == nil) {
                    userDefaults.setObject(NSDate(), forKey: userDefaultsScheduleTeacherKey)
                    completionHandler(items, error)
                } else {
                    self.featchScheduleFromCache(teacher, dateStart: dateStart, dateEnd: dateEnd, completionHandler: completionHandler)
                }
            })
        } else {
            featchScheduleFromCache(teacher, dateStart: dateStart, dateEnd: dateEnd, completionHandler: completionHandler)
        }
    }
    
    class func featchSchedule(teacher : TeacherInfoEntity, dateStart: NSDate, dateEnd: NSDate, completionHandler: ((Array<LessonScheduleEntity>?, NSError?) -> Void)!) {
        
        let path = "/getTeacherScheduleFake"
        
        let queryItems = [
            NSURLQueryItem(name: "teacherId", value: teacher.id),
            NSURLQueryItem(name: "dateStart", value: DateUtils.formatDate(dateStart, withFormat: DateFormatDayMonthYear2)),
            NSURLQueryItem(name: "dateEnd", value: DateUtils.formatDate(dateEnd, withFormat: DateFormatDayMonthYear2))
        ]
        
        resumeRequest(path, queryItems: queryItems, completionHandler: { (result: NSDictionary?, error: NSError?) -> Void in
            
            if (error == nil) {
                self.storeSchedule(teacher, dateStart: dateStart, dateEnd: dateEnd, result: result, completionHandler: completionHandler)
            } else {
                completionHandler(nil, error)
            }
        })
    }

    class func storeSchedule(teacher : TeacherInfoEntity, dateStart: NSDate, dateEnd: NSDate, result: NSDictionary?, completionHandler: ((Array<LessonScheduleEntity>?, NSError?) -> Void)!) {
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        let cdHelper = delegate.cdh
        if let context = cdHelper.backgroundContext {
            context.performBlock({ () -> Void in
                
                let teacher_ = context.objectWithID(teacher.objectID) as TeacherInfoEntity
                
                var request = NSFetchRequest(entityName: LessonScheduleEntityName)
                let predicate = NSPredicate(format: "(isTeacherSchedule == YES) && (teacher == %@) && (date >= %@) && (date <= %@)", teacher_, dateStart, dateEnd)
                request.predicate = predicate
                
                var error : NSError?
                var cacheItems = context.executeFetchRequest(request, error: &error) as [NSManagedObject]
                for item in cacheItems {
                    context.deleteObject(item)
                }
                
                request = NSFetchRequest(entityName: FacultiesEntityName)
                let _facultyCacheItems = context.executeFetchRequest(request, error: &error) as [FacultiesEntity]
                var facultyCacheItems = Dictionary<String, FacultiesEntity>(minimumCapacity: cacheItems.count)
                _facultyCacheItems.map { facultyCacheItems[$0.id] = $0 }

                request = NSFetchRequest(entityName: GroupsEntityName)
                let _groupCacheItems = context.executeFetchRequest(request, error: &error) as [GroupsEntity]
                var groupCacheItems = Dictionary<String, GroupsEntity>(minimumCapacity: cacheItems.count)
                _groupCacheItems.map { groupCacheItems[$0.id] = $0 }

                
                var lessonSchedule : [LessonScheduleEntity] = Array()
                if let days = result?["days"] as? [NSDictionary] {
                    
                    for day in days {
                        let strDate = day["date"] as String
                        let date = DateUtils.dateFromString(strDate, format: DateFormatKeyDateInDefaultFormat)
                        
                        if let lessons = day["lessons"] as? [NSDictionary] {
                            
                            for lesson in lessons {
                                let timeStart = lesson["timeStart"] as String
                                let timeEnd = lesson["timeEnd"] as String
                                let groupsDict = lesson["group"] as [NSDictionary]? ?? []
                                let course = lesson["course"] as Int
                                let facultyDict = lesson["faculty"] as NSDictionary?
                                
                                var faculty: FacultiesEntity!
                                if let facultyDict = facultyDict {
                                    let idInt = facultyDict["id"] as? Int ?? 0
                                    let id = "\(idInt)"
                                    faculty = facultyCacheItems[id]
                                    if (faculty == nil) {
                                        faculty = NSEntityDescription.insertNewObjectForEntityForName(FacultiesEntityName, inManagedObjectContext: context) as? FacultiesEntity
                                        faculty?.id = id
                                        faculty?.title = facultyDict["title"] as? String ?? ""
                                    }
                                }
                                
                                var groups = NSMutableSet()
                                for groupDict in groupsDict {
                                    let idInt = groupDict["id"] as? Int ?? 0
                                    let id = "\(idInt)"
                                    var group = groupCacheItems[id]
                                    if (group == nil) {
                                        group = NSEntityDescription.insertNewObjectForEntityForName(GroupsEntityName, inManagedObjectContext: context) as? GroupsEntity
                                        group?.id = id
                                        group?.title = groupDict["title"] as? String ?? ""
                                        group?.course = "\(course)"
                                        group?.faculty = faculty
                                    }
                                    groups.addObject(group!)
                                }
                                
                                var newlesson = NSEntityDescription.insertNewObjectForEntityForName(LessonScheduleEntityName, inManagedObjectContext: context) as LessonScheduleEntity
                                newlesson.isTeacherSchedule = true
                                newlesson.teacher = teacher_
                                newlesson.groups = groups
                                newlesson.date = date
                                newlesson.studyName = lesson["title"] as? String ?? ""
                                newlesson.type = lesson["type"] as? String ?? ""
                                newlesson.address = lesson["address"] as? String ?? ""
                                newlesson.room = lesson["room"] as String? ?? ""
                                newlesson.startTime = DateManager.timeIntervalWithTimeText(timeStart)
                                newlesson.stopTime = DateManager.timeIntervalWithTimeText(timeEnd)
                                newlesson.subgroupTitle = ""
                                
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

    class func featchScheduleFromCache(teacher : TeacherInfoEntity, dateStart: NSDate, dateEnd: NSDate, completionHandler: ((Array<LessonScheduleEntity>?, NSError?) -> Void)!) {
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        let cdHelper = delegate.cdh
        if let context = cdHelper.backgroundContext {
            context.performBlock({ () -> Void in
                
                let request = NSFetchRequest(entityName: LessonScheduleEntityName)
                var sorter: NSSortDescriptor = NSSortDescriptor(key: "date" , ascending: true)
                let teacher_ = context.objectWithID(teacher.objectID) as TeacherInfoEntity
                let predicate = NSPredicate(format: "(isTeacherSchedule == YES) && (teacher == %@) && (date >= %@) && (date <= %@)", teacher_, dateStart, dateEnd)
                
                request.resultType = .ManagedObjectIDResultType
                request.sortDescriptors = [sorter]
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
    
}
