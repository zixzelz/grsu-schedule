//
//  GetTeachersService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/10/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit
import CoreData

typealias GetTeachersCompletionHandlet = ServiceResult<[TeacherInfoEntity], NSError> -> Void

class GetTeachersService_: BaseDataService {

    // MARK: - Teacher

    class func getTeacher(teacherId: String, completionHandler: (ServiceResult<TeacherInfoEntity, NSError> -> Void)!) {
        getTeacher(teacherId, useCache: true, completionHandler: completionHandler)
    }

    class func getTeacher(teacherId: String, useCache: Bool, completionHandler: (ServiceResult<TeacherInfoEntity, NSError> -> Void)) {

        if (useCache == false) {
            featchTeacher(teacherId) { result -> Void in

                switch result {
                case .Failure: self.featchTeacherFromCache(teacherId, completionHandler: completionHandler)
                case .Success: completionHandler(result)
                }
            }
        } else {

            featchTeacherFromCache(teacherId, completionHandler: { result -> Void in

//                let expiryDate = teacherInfo?.updatedDate.dateByAddingTimeInterval(TeacherCacheTimeInterval)
//
//                if (expiryDate == nil || expiryDate!.compare(NSDate()) == .OrderedAscending) {
//                    self.featchTeacher(teacherId) { (item: TeacherInfoEntity?, error: NSError?) -> Void in
//                        if let item = item {
//                            completionHandler(item, error)
//                        } else {
//                            completionHandler(teacherInfo, error)
//                        }
//                    }
//                } else {
//                    completionHandler(teacherInfo, error)
//                }

            })

        }
    }

    // MARK: - Teachers

    class func getTeachers(completionHandler: GetTeachersCompletionHandlet) {
        getTeachers(true, completionHandler: completionHandler)
    }

    class func getTeachers(useCache: Bool, completionHandler: GetTeachersCompletionHandlet) {

        let userDefaults = NSUserDefaults.standardUserDefaults()
        let userDefaultsTeachersKey = "TeachersKey"
        let date = userDefaults.objectForKey(userDefaultsTeachersKey) as? NSDate
        let expiryDate = date?.dateByAddingTimeInterval(TeachersCacheTimeInterval)

        if (useCache == false || expiryDate == nil || expiryDate!.compare(NSDate()) == .OrderedAscending) {
            featchTeachers({ (error: NSError?) -> Void in
                self.featchTeachersFromCache(completionHandler)
                userDefaults.synchronize()
                userDefaults.setObject(NSDate(), forKey: userDefaultsTeachersKey)
            })
        } else {
            featchTeachersFromCache(completionHandler)
        }
    }

    // MARK: - Private

    private class func featchTeacherFromCache(teacherId: String?, completionHandler: (ServiceResult<TeacherInfoEntity, NSError> -> Void)) {

        self.featchTeachersFromCache(teacherId) { (result) -> Void in

            switch result {
            case .Failure(let error): completionHandler(.Failure(error))
            case .Success(let items): completionHandler(.Success(items.first!))
            }
        }
    }

    private class func featchTeachersFromCache(completionHandler: GetTeachersCompletionHandlet) {
        self.featchTeachersFromCache(nil, completionHandler: completionHandler)
    }

    private class func featchTeachersFromCache(teacherId: String?, completionHandler: GetTeachersCompletionHandlet) {

        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let cdHelper = delegate.cdh
        let context = cdHelper.backgroundContext

        context.performBlock { () -> Void in

            let request = NSFetchRequest(entityName: TeacherInfoEntityName)
            let sorter = NSSortDescriptor(key: "title", ascending: true)
            if let id = teacherId {
                request.predicate = NSPredicate(format: "(id == %@)", id)
            }

            request.resultType = .ManagedObjectIDResultType
            request.sortDescriptors = [sorter]

            do {
                let itemIds = try context.executeFetchRequest(request) as! [NSManagedObjectID]

                dispatch_async(dispatch_get_main_queue()) { _ in

                    let items = cdHelper.convertToMainQueue(itemIds) as! [TeacherInfoEntity]

                    completionHandler(.Success(items))
                }
            }
            catch let error as NSError {

                NSLog("executeFetchRequest error: \(error)")
                completionHandler(.Failure(error))
            }
        }
    }

    private class func featchTeachers(completionHandler: ((NSError?) -> Void)!) {

        let path = "/getTeachers"

        resumeRequest(path, queryItems: nil) { result -> Void in

            switch result {
            case .Failure(let error): completionHandler(error)
            case .Success(let dict):

                let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let cdHelper = delegate.cdh

                if let items = dict["items"] as? [NSDictionary] {

                    let context = cdHelper.backgroundContext
                    context.performBlock { _ in

                        let request = NSFetchRequest(entityName: TeacherInfoEntityName)

                        let cachedTeachers = try! context.executeFetchRequest(request) as! [TeacherInfoEntity]
                        let cachedTeachersDictionary = cachedTeachers.dict { ($0.id, $0) }

                        for item in items {

                            let id = item["id"] as! String
                            var teacher: TeacherInfoEntity? = cachedTeachersDictionary[id]

                            if (teacher == nil) {
                                teacher = NSEntityDescription.insertNewObjectForEntityForName(TeacherInfoEntityName, inManagedObjectContext: context) as? TeacherInfoEntity
                                teacher!.id = item["id"] as! String
                            }

                            if (teacher!.title != item["fullname"] as? String) {
                                teacher!.title = item["fullname"] as? String
                            }
                        }

                        cdHelper.saveContext(context)

                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completionHandler(nil)
                        })
                    }
                }
            }
        }
    }

    private class func featchTeacher(teacherId: String, completionHandler: ServiceResult<TeacherInfoEntity, NSError> -> Void) {

        let path = "/getTeachers"
        let queryItems = "teacherId=\(teacherId)&extended=true"

        resumeRequest(path, queryItems: queryItems, completionHandler: { result -> Void in

            switch result {
            case .Failure(let error): completionHandler(.Failure(error))
            case .Success(let dict):

                let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let cdHelper = delegate.cdh

                let items = dict["items"] as? [NSDictionary]

                if items?.count == 1 {

                    let item = items!.first!
                    let context = cdHelper.backgroundContext
                    context.performBlock { () -> Void in

                        let request = NSFetchRequest(entityName: TeacherInfoEntityName)
                        request.predicate = NSPredicate(format: "(id == %@)", teacherId)

                        let items = try? context.executeFetchRequest(request)
                        var teacher = items?.first as? TeacherInfoEntity

                        if (teacher == nil) {
                            teacher = NSEntityDescription.insertNewObjectForEntityForName(TeacherInfoEntityName, inManagedObjectContext: context) as? TeacherInfoEntity
                            teacher!.id = item["id"] as! String
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

                        dispatch_async(dispatch_get_main_queue(), { _ in

                            let mTeacher = cdHelper.managedObjectContext.objectWithID(teacher!.objectID) as! TeacherInfoEntity
                            completionHandler(.Success(mTeacher))
                        })

                    }
                } else {
                    completionHandler(.Failure(NSError(domain: "", code: -1, userInfo: nil)))
                }
            }

        })
    }

}
