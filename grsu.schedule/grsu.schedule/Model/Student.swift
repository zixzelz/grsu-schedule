//
//  Student.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/21/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

class Student: NSObject, NSCoding {

    var fullName: String?
    var groupTitle: String?
    var id: Int
    var studentType: String?
    
    init(json: [String: AnyObject]) throws {

        guard let _id = json["id"] as? Int where _id != 0,
        let k_sgryp = json["k_sgryp"] as? Int where k_sgryp != 0 else {
            throw ServiceError.WrongResponseFormat
        }
        
        id = _id
        fullName = json["fullname"] as? String
        groupTitle = json["grouptitle"] as? String
        studentType = json["studenttype"] as? String
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fullName = aDecoder.decodeObjectForKey("fullName") as? String
        groupTitle = aDecoder.decodeObjectForKey("groupTitle") as? String
        id = aDecoder.decodeObjectForKey("id") as? Int ?? 0
        studentType = aDecoder.decodeObjectForKey("studentType") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(fullName, forKey: "fullName")
        aCoder.encodeObject(groupTitle, forKey: "groupTitle")
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(studentType, forKey: "studentType")
    }

}
