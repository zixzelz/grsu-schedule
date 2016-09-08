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

    class func getSchedule(teacher: TeacherInfoEntity, dateStart: NSDate, dateEnd: NSDate, completionHandler: ((Array<LessonScheduleEntity>?, NSError?) -> Void)!) {

        getSchedule(teacher, dateStart: dateStart, dateEnd: dateEnd, cache: .CachedElseLoad, completionHandler: completionHandler)
    }

    class func getSchedule(teacher: TeacherInfoEntity, dateStart: NSDate, dateEnd: NSDate, cache: CachePolicy, completionHandler: ((Array<LessonScheduleEntity>?, NSError?) -> Void)!) {

        let userDefaults = NSUserDefaults.standardUserDefaults()
        let userDefaultsScheduleTeacherKey = "ScheduleTeacherKey \(teacher.id).\(dateStart)"
        let date = userDefaults.objectForKey(userDefaultsScheduleTeacherKey) as? NSDate
        let expiryDate = date?.dateByAddingTimeInterval(ScheduleCacheTimeInterval)

        if (useCache == false || expiryDate == nil || expiryDate!.compare(NSDate()) == .OrderedAscending) {
            featchSchedule(teacher, dateStart: dateStart, dateEnd: dateEnd, completionHandler: { (items: Array<LessonScheduleEntity>?, error: NSError?) -> Void in
                if (error == nil) {
                    userDefaults.setObject(NSDate(), forKey: userDefaultsScheduleTeacherKey)
                    userDefaults.synchronize()
                    completionHandler(items, error)
                } else {
                    self.featchScheduleFromCache(teacher, dateStart: dateStart, dateEnd: dateEnd, completionHandler: completionHandler)
                }
            })
        } else {
            featchScheduleFromCache(teacher, dateStart: dateStart, dateEnd: dateEnd, completionHandler: completionHandler)
        }
    }

    class func featchSchedule(teacher: TeacherInfoEntity, dateStart: NSDate, dateEnd: NSDate, completionHandler: ((Array<LessonScheduleEntity>?, NSError?) -> Void)!) {

        let path = "/getTeacherSchedule"

        let queryItems = "teacherId=\(teacher.id)&dateStart=\(DateUtils.formatDate(dateStart, withFormat: DateFormatDayMonthYear2))&dateEnd=\(DateUtils.formatDate(dateEnd, withFormat: DateFormatDayMonthYear2))"

        resumeRequest(path, queryItems: queryItems) { result in

            switch result {
            case .Failure(let error): completionHandler(nil, error)
            case .Success(let dict): self.storeSchedule(teacher, dateStart: dateStart, dateEnd: dateEnd, result: dict, completionHandler: completionHandler)
            }
        }
    }

    class func storeSchedule(teacher: TeacherInfoEntity, dateStart: NSDate, dateEnd: NSDate, result: NSDictionary?, completionHandler: ((Array<LessonScheduleEntity>?, NSError?) -> Void)!) {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let cdHelper = delegate.cdh

        let context = cdHelper.backgroundContext
        context.performBlock({ () -> Void in

            let teacher_ = context.objectWithID(teacher.objectID) as! TeacherInfoEntity

            var request = NSFetchRequest(entityName: LessonScheduleEntityName)
            let predicate = NSPredicate(format: "(isTeacherSchedule == YES) && (teacher == %@) && (date >= %@) && (date <= %@)", teacher_, dateStart, dateEnd)
            request.predicate = predicate

            let cacheItems = try! context.executeFetchRequest(request) as! [NSManagedObject]
            for item in cacheItems {
                context.deleteObject(item)
            }

            request = NSFetchRequest(entityName: DepartmentsEntityName)
            let _departmentCacheItems = try! context.executeFetchRequest(request) as! [DepartmentsEntity]
            var departmentCacheItems = _departmentCacheItems.dict { ($0.id, $0) }

            request = NSFetchRequest(entityName: FacultiesEntityName)
            let _facultyCacheItems = try! context.executeFetchRequest(request) as! [FacultiesEntity]
            var facultyCacheItems = _facultyCacheItems.dict { ($0.id, $0) }

            request = NSFetchRequest(entityName: GroupsEntityName)
            let _groupCacheItems = try! context.executeFetchRequest(request) as! [GroupsEntity]
            var groupCacheItems = _groupCacheItems.dict { ($0.id, $0) }

            var lessonSchedule: [LessonScheduleEntity] = Array()
            if let days = result?["days"] as? [NSDictionary] {

                for day in days {

                    let strDate = day["date"] as! String
                    let date = DateUtils.dateFromString(strDate, format: DateFormatKeyDateInDefaultFormat)

                    if let lessons = day["lessons"] as? [NSDictionary] {

                        for lesson in lessons {
                            let timeStart = lesson["timeStart"] as! String
                            let timeEnd = lesson["timeEnd"] as! String
                            let groupsDict = lesson["groups"] as? [NSDictionary] ?? [NSDictionary]()

                            var groups = Set<GroupsEntity>()
                            for groupDict in groupsDict {
                                let id = groupDict["id"] as? String ?? "0"
                                var group = groupCacheItems[id]
                                if (group == nil) {
                                    let departmentDict = groupDict["department"] as? NSDictionary
                                    let facultyDict = groupDict["faculty"] as? NSDictionary

                                    // department
                                    var department: DepartmentsEntity?
                                    if let departmentDict = departmentDict {
                                        let id = departmentDict["id"] as? String ?? "0"
                                        department = departmentCacheItems[id]
                                        if (department == nil) {
                                            department = NSEntityDescription.insertNewObjectForEntityForName(DepartmentsEntityName, inManagedObjectContext: context) as? DepartmentsEntity
                                            department?.id = id
                                            department?.title = departmentDict["title"] as? String ?? ""
                                            departmentCacheItems[id] = department
                                        }
                                    }

                                    // faculty
                                    var faculty: FacultiesEntity?
                                    if let facultyDict = facultyDict {
                                        let id = facultyDict["id"] as? String ?? "0"
                                        faculty = facultyCacheItems[id]
                                        if (faculty == nil) {
                                            faculty = NSEntityDescription.insertNewObjectForEntityForName(FacultiesEntityName, inManagedObjectContext: context) as? FacultiesEntity
                                            faculty?.id = id
                                            faculty?.title = facultyDict["title"] as? String ?? ""
                                            facultyCacheItems[id] = faculty
                                        }
                                    }

                                    group = NSEntityDescription.insertNewObjectForEntityForName(GroupsEntityName, inManagedObjectContext: context) as? GroupsEntity
                                    group?.id = id
                                    group?.title = groupDict["title"] as? String ?? ""
                                    group?.course = groupDict["course"] as? String ?? "0"
                                    group?.department = department
                                    group?.faculty = faculty
                                    groupCacheItems[id] = group
                                }
                                groups.insert(group!)
                            }

                            let newlesson = NSEntityDescription.insertNewObjectForEntityForName(LessonScheduleEntityName, inManagedObjectContext: context) as! LessonScheduleEntity
                            newlesson.isTeacherSchedule = true
                            newlesson.teacher = teacher_
                            newlesson.groups = groups
                            newlesson.date = date
                            newlesson.studyName = lesson["title"] as? String ?? "Нет данных"
                            newlesson.type = lesson["type"] as? String ?? ""
                            newlesson.address = lesson["address"] as? String ?? ""
                            newlesson.room = lesson["room"] as? String ?? ""
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

    }

    class func featchScheduleFromCache(teacher: TeacherInfoEntity, dateStart: NSDate, dateEnd: NSDate, completionHandler: ((Array<LessonScheduleEntity>?, NSError?) -> Void)!) {

        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let cdHelper = delegate.cdh

        let context = cdHelper.backgroundContext
        context.performBlock({ () -> Void in

            let request = NSFetchRequest(entityName: LessonScheduleEntityName)
            var sorter: NSSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
            var lessonSorter = NSSortDescriptor(key: "startTime", ascending: true)
            let teacher_ = context.objectWithID(teacher.objectID) as! TeacherInfoEntity
            let predicate = NSPredicate(format: "(isTeacherSchedule == YES) && (teacher == %@) && (date >= %@) && (date <= %@)", teacher_, dateStart, dateEnd)

            request.resultType = .ManagedObjectIDResultType
            request.sortDescriptors = [sorter, lessonSorter]
            request.predicate = predicate

            let itemIds = try! context.executeFetchRequest(request) as! [NSManagedObjectID]

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                var items: [LessonScheduleEntity]?
                if error == nil {
                    items = cdHelper.convertToMainQueue(itemIds) as? [LessonScheduleEntity]
                } else {
                    NSLog("executeFetchRequest error: %@", error!)
                }

                completionHandler(items, error)
            })
        })
    }

}
