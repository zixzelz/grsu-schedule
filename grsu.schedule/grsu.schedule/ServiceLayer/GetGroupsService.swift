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

    class func getGroups(faculty: FacultiesEntity, department: DepartmentsEntity, course: String, completionHandler: ((Array<GroupsEntity>?, NSError?) -> Void)!) {
        
        getGroups(faculty, department: department, course: course, useCache: true, completionHandler: completionHandler)
    }
    
    class func getGroups(faculty: FacultiesEntity, department: DepartmentsEntity, course: String, useCache: Bool, completionHandler: ((Array<GroupsEntity>?, NSError?) -> Void)!) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let userDefaultsGroupKey = "GroupsKey \(faculty.id).\(department.id).\(course)"
        let date = userDefaults.objectForKey(userDefaultsGroupKey) as NSDate?
        let expiryDate = date?.dateByAddingTimeInterval(GroupsCacheTimeInterval)
        
        if (useCache == false || expiryDate == nil || expiryDate!.compare(NSDate()) == .OrderedAscending ) {
            featchGroups(faculty, department: department, course: course, { (items: Array<GSItem>?, error: NSError?) -> Void in
                if (items?.count > 0) {
                    self.storeGroups(faculty, department: department, course: course, items: items!, completionHandler: { () -> Void in
                        userDefaults.setObject(NSDate(), forKey: userDefaultsGroupKey)
                        self.featchGroupsFromCache(faculty, department: department, course: course, completionHandler: completionHandler)
                    })
                } else {
                    self.featchGroupsFromCache(faculty, department: department, course: course, completionHandler: completionHandler)
                }
            })
        } else {
            featchGroupsFromCache(faculty, department: department, course: course, completionHandler: completionHandler)
        }
    }
    
    class func featchGroups(faculty: FacultiesEntity, department: DepartmentsEntity, course: String, completionHandler: ((Array<GSItem>?, NSError?) -> Void)!) {
        
        let path = "/getGroups"
        
        let queryItems = [
            NSURLQueryItem(name: "facultyId", value: faculty.id),
            NSURLQueryItem(name: "departmentId", value: department.id),
            NSURLQueryItem(name: "course", value: course),
        ]
        
        resumeRequest(path, queryItems: queryItems, completionHandler: { (result: NSDictionary?, error: NSError?) -> Void in

            var res : [GSItem] = Array()
            if let items = result?["items"] as? [NSDictionary] {
                
                for item in items {
                    let gsItem = GSItem(item["id"] as String, item["title"] as String)
                    res.append(gsItem)
                }
                
            }
            
            completionHandler(res, error)
        })
    }
    
    class func featchGroupsFromCache(faculty: FacultiesEntity, department: DepartmentsEntity, course: String, completionHandler: ((Array<GroupsEntity>?, NSError?) -> Void)!) {
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        let cdHelper = delegate.cdh
        if let context = cdHelper.backgroundContext {
            context.performBlock({ () -> Void in
                
                let request = NSFetchRequest(entityName: GroupsEntityName)
                var sorter: NSSortDescriptor = NSSortDescriptor(key: "id" , ascending: true)
                let predicate = NSPredicate(format: "(faculty == %@) && (department == %@) && (course == %@)", faculty, department, course)
                
                request.resultType = .ManagedObjectIDResultType
                request.sortDescriptors = [sorter]
                request.predicate = predicate
                
                var error : NSError?
                let itemIds = context.executeFetchRequest(request, error: &error) as [NSManagedObjectID]
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var items : [GroupsEntity]?
                    if error == nil {
                        items = cdHelper.convertToMainQueue(itemIds) as? [GroupsEntity]
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
    
    class func storeGroups(faculty: FacultiesEntity, department: DepartmentsEntity, course: String, items: Array<GSItem>, completionHandler: ( () -> Void)!) {
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        let cdHelper = delegate.cdh
        if let context = cdHelper.backgroundContext {
            context.performBlock({ () -> Void in
                
                let faculty_ = context.objectWithID(faculty.objectID) as FacultiesEntity
                let department_ = context.objectWithID(department.objectID) as DepartmentsEntity
                
                let request = NSFetchRequest(entityName: GroupsEntityName)
                let predicate = NSPredicate(format: "(faculty == %@) && (department == %@) && (course == %@)", faculty, department, course)
                request.predicate = predicate
                
                var error : NSError?
                let cacheItems = context.executeFetchRequest(request, error: &error) as [GroupsEntity]
                
                var handledItems: [GroupsEntity] = Array()
                for item in items {
                    
                    var oldItem = cacheItems.filter { $0.id == item.id }.first as GroupsEntity?
                    
                    if (oldItem == nil) {
                        var newItem = NSEntityDescription.insertNewObjectForEntityForName(GroupsEntityName, inManagedObjectContext: context) as GroupsEntity
                        
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
                    
                    if !contains(handledItems, item) {
                        context.deleteObject(item)
                    }
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

}
