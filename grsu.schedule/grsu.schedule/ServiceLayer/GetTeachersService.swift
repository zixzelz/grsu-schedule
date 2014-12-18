//
//  GetTeachersService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/10/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit
import CoreData

class GetTeachersService: BaseDataService {
   
    // MARK: - Teacher
    
    class func getTeacher(teacherId : String, completionHandler: ((TeacherInfoEntity?, NSError?) -> Void)!) {
        getTeacher(teacherId, useCache: true, completionHandler: completionHandler)
    }
    
    class func getTeacher(teacherId : String, useCache: Bool, completionHandler: ((TeacherInfoEntity?, NSError?) -> Void)!) {
        
        if (useCache == false) {
            featchTeacher(teacherId, completionHandler: completionHandler)
        } else {
            
            featchTeacherFromCache(teacherId, completionHandler: { (items: Array<TeacherInfoEntity>?, error: NSError?) -> Void in
                let item = items?.first
                let expiryDate = item?.updatedDate.dateByAddingTimeInterval(TeacherCacheTimeInterval)
                
                if (expiryDate == nil || expiryDate!.compare(NSDate()) == .OrderedAscending ) {
                    self.featchTeacher(teacherId, completionHandler: completionHandler)
                } else {
                    completionHandler(item, error)
                }

            })
            
        }
        
    }
    
    // MARK: - Teachers
    
    class func getTeachers(completionHandler: ((Array<TeacherInfoEntity>?, NSError?) -> Void)!) {
        getTeachers(true, completionHandler: completionHandler)
    }
    
    class func getTeachers(useCache: Bool, completionHandler: ((Array<TeacherInfoEntity>?, NSError?) -> Void)!) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let userDefaultsTeachersKey = "TeachersKey"
        let date = userDefaults.objectForKey(userDefaultsTeachersKey) as NSDate?
        let expiryDate = date?.dateByAddingTimeInterval(TeachersCacheTimeInterval)
        
        if (useCache == false || expiryDate == nil || expiryDate!.compare(NSDate()) == .OrderedAscending) {
            featchTeachers({ (error: NSError?) -> Void in
                self.featchTeacherFromCache(nil, completionHandler: completionHandler)
                userDefaults.setObject(NSDate(), forKey: userDefaultsTeachersKey)
            })
        } else {
            featchTeacherFromCache(nil, completionHandler: completionHandler)
        }
    }

    // MARK: - Private
    
    private class func featchTeacherFromCache(teacherId : String?, completionHandler: ((Array<TeacherInfoEntity>?, NSError?) -> Void)!) {
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        let cdHelper = delegate.cdh
        if let context = cdHelper.backgroundContext {
            context.performBlock({ () -> Void in
                
                let request = NSFetchRequest(entityName: TeacherInfoEntityName)
                var sorter: NSSortDescriptor = NSSortDescriptor(key: "title" , ascending: true)
                if let id = teacherId {
                    request.predicate = NSPredicate(format: "(id == %@)", id)
                }
                
                request.resultType = .ManagedObjectIDResultType
                request.sortDescriptors = [sorter]
                
                var error : NSError?
                let itemIds = context.executeFetchRequest(request, error: &error) as [NSManagedObjectID]
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var items : [TeacherInfoEntity]?
                    if error == nil {
                        items = cdHelper.convertToMainQueue(itemIds) as? [TeacherInfoEntity]
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
    
    private class func featchTeachers(completionHandler: ((NSError?) -> Void)!) {
        
        let path = "/getTeachers"
        
        resumeRequest(path, queryItems: nil, completionHandler: { (result: NSDictionary?, error: NSError?) -> Void in
            
            let delegate = UIApplication.sharedApplication().delegate as AppDelegate
            let cdHelper = delegate.cdh
            
            if let items = result?["items"] as? [NSDictionary] {
                
                if let context = cdHelper.backgroundContext {
                    context.performBlock({ () -> Void in
                        
                        let request = NSFetchRequest(entityName: TeacherInfoEntityName)
                        var error : NSError?
                        let cachedTeachers = context.executeFetchRequest(request, error: &error) as [TeacherInfoEntity]
                        
                        var cachedTeachersDictionary = Dictionary<String, TeacherInfoEntity>(minimumCapacity: cachedTeachers.count)
                        cachedTeachers.map { cachedTeachersDictionary[$0.id] = $0 }
                        
                        var res : [TeacherInfoEntity] = Array()
                        for item in items {
                            
                            var id = item["id"] as String
                            var teacher: TeacherInfoEntity? = cachedTeachersDictionary[id]
                            
                            if (teacher == nil) {
                                teacher = NSEntityDescription.insertNewObjectForEntityForName(TeacherInfoEntityName, inManagedObjectContext: context) as? TeacherInfoEntity
                                teacher!.id = item["id"] as String
                            }
                            
                            if (teacher!.title != item["fullname"] as? String) {
                                teacher!.title = item["fullname"] as? String
                            }
                        }
                        
                        cdHelper.saveContext(context)

                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completionHandler(error)
                        })
                    })
                }
            } else {
                completionHandler(error)
            }
            
        })
    }
    
    private class func featchTeacher(teacherId : String, completionHandler: ((TeacherInfoEntity?, NSError?) -> Void)!) {
        
        let path = "/getTeachers"
        
        var queryItems = [
                NSURLQueryItem(name: "teacherId", value: teacherId),
                NSURLQueryItem(name: "extended", value: "true")
            ]
        
        resumeRequest(path, queryItems: queryItems, completionHandler: { (result: NSDictionary?, error: NSError?) -> Void in
            
            let cachedTeachers : [TeacherInfoEntity] = []
            let delegate = UIApplication.sharedApplication().delegate as AppDelegate
            let cdHelper = delegate.cdh

            let items = result?["items"] as? [NSDictionary]
            
            if let item = items?.first {

                if let context = cdHelper.backgroundContext {
                    context.performBlock({ () -> Void in
                        
                        let request = NSFetchRequest(entityName: TeacherInfoEntityName)
                        request.predicate = NSPredicate(format: "(id == %@)", teacherId)
                        var error : NSError?
                        let items = context.executeFetchRequest(request, error: &error)
                        var teacher = items?.first as TeacherInfoEntity?
                        
                        if (teacher == nil) {
                            teacher = NSEntityDescription.insertNewObjectForEntityForName(TeacherInfoEntityName, inManagedObjectContext: context) as? TeacherInfoEntity
                            teacher!.id = item["id"] as String
                        }
                        teacher!.name = item["name"] as? String
                        teacher!.surname = item["surname"] as? String
                        teacher!.patronym = item["patronym"] as? String
                        teacher!.post = item["post"] as? String
                        teacher!.phone = item["phone"] as? String
                        teacher!.descr = item["descr"] as? String
                        teacher!.email = item["email"] as? String
                        teacher!.skype = item["skype"] as? String
                        teacher!.updatedDate = NSDate()
                        
                        cdHelper.saveContext(context)

                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let mTeacher = cdHelper.managedObjectContext?.objectWithID(teacher!.objectID) as TeacherInfoEntity
                            completionHandler(mTeacher, error)
                        })

                    })
                }
            } else {
                completionHandler(nil, error)
            }
            
        })
    }
    
}
