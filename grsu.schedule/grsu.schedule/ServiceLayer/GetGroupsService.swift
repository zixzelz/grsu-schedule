//
//  GetGroupsService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/21/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit
import CoreData

class GetGroupsService: BaseDataService {

    class func getGroups(faculty: FacultiesEntity, department: DepartmentsEntity, course: String, completionHandler: (([GroupsEntity]?, NSError?) -> Void)!) {

        getGroups(faculty, department: department, course: course, useCache: true, completionHandler: completionHandler)
    }

    class func getGroups(faculty: FacultiesEntity, department: DepartmentsEntity, course: String, useCache: Bool, completionHandler: (([GroupsEntity]?, NSError?) -> Void)!) {

        let userDefaults = NSUserDefaults.standardUserDefaults()
        let userDefaultsGroupKey = "GroupsKey \(faculty.id).\(department.id).\(course)"
        let date = userDefaults.objectForKey(userDefaultsGroupKey) as? NSDate
        let expiryDate = date?.dateByAddingTimeInterval(GroupsCacheTimeInterval)

        if (useCache == false || expiryDate == nil || expiryDate!.compare(NSDate()) == .OrderedAscending) {
            featchGroups(faculty, department: department, course: course) { (items: Array<GSItem>?, error: NSError?) -> Void in
                if (items?.count > 0) {
                    self.storeGroups(faculty, department: department, course: course, items: items!, completionHandler: { () -> Void in
                        userDefaults.setObject(NSDate(), forKey: userDefaultsGroupKey)
                        userDefaults.synchronize()
                        self.featchGroupsFromCache(faculty, department: department, course: course, completionHandler: completionHandler)
                    })
                } else {
                    self.featchGroupsFromCache(faculty, department: department, course: course, completionHandler: completionHandler)
                }
            }
        } else {
            featchGroupsFromCache(faculty, department: department, course: course, completionHandler: completionHandler)
        }
    }

    class func featchGroups(faculty: FacultiesEntity, department: DepartmentsEntity, course: String, completionHandler: ((Array<GSItem>?, NSError?) -> Void)!) {

        let path = "/getGroups"

        let queryItems = "facultyId=\(faculty.id)&departmentId=\(department.id)&course=\(course)"

        resumeRequest(path, queryItems: queryItems, completionHandler: { result in

            var res: [GSItem] = Array()
            if case .Success(let dict) = result, let items = dict["items"] as? [NSDictionary] {

                for item in items {
                    let gsItem = GSItem(item["id"] as! String, item["title"] as! String)
                    res.append(gsItem)
                }

                completionHandler(res, nil)
            } else if case let .Failure(error) = result {

                completionHandler(nil, error)
            }

        })
    }

    class func featchGroupsFromCache(faculty: FacultiesEntity, department: DepartmentsEntity, course: String, completionHandler: ((Array<GroupsEntity>?, NSError?) -> Void)!) {

        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let cdHelper = delegate.cdh
        let context = cdHelper.backgroundContext
        context.performBlock({ () -> Void in

            let request = NSFetchRequest(entityName: GroupsEntityName)
            let sorter: NSSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            let predicate = NSPredicate(format: "(faculty == %@) && (department == %@) && (course == %@)", faculty, department, course)

            request.resultType = .ManagedObjectIDResultType
            request.sortDescriptors = [sorter]
            request.predicate = predicate

            let itemIds = try! context.executeFetchRequest(request) as! [NSManagedObjectID]

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let items = cdHelper.convertToMainQueue(itemIds) as? [GroupsEntity]
                completionHandler(items, nil)
            })
        })
    }

    class func storeGroups(faculty: FacultiesEntity, department: DepartmentsEntity, course: String, items: Array<GSItem>, completionHandler: (() -> Void)!) {

        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let cdHelper = delegate.cdh

        let context = cdHelper.backgroundContext
        context.performBlock({ () -> Void in

            let faculty_ = context.objectWithID(faculty.objectID) as! FacultiesEntity
            let department_ = context.objectWithID(department.objectID) as! DepartmentsEntity

            let request = NSFetchRequest(entityName: GroupsEntityName)
            let predicate = NSPredicate(format: "(faculty == %@) && (department == %@) && (course == %@)", faculty, department, course)
            request.predicate = predicate
 
            let cacheItems = try! context.executeFetchRequest(request) as! [GroupsEntity]

            var handledItems: [GroupsEntity] = Array()
            for item in items {

                var oldItem = cacheItems.filter { $0.id == item.id }.first

                if (oldItem == nil) {
                    let newItem = NSEntityDescription.insertNewObjectForEntityForName(GroupsEntityName, inManagedObjectContext: context) as! GroupsEntity

                    newItem.id = item.id
                    newItem.title = item.value
                    newItem.faculty = faculty_
                    newItem.department = department_
                    newItem.course = course

                    oldItem = newItem
                } else {
                    oldItem!.title = item.value
                }
                handledItems.append(oldItem!)
            }

            for item in cacheItems {

                if !handledItems.contains(item) {
                    context.deleteObject(item)
                }
            }

            cdHelper.saveContext(context)

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler()
            })
        })
    }

}
