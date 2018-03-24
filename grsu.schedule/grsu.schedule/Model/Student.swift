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
    
    init?(json: [String: AnyObject]) {

        guard let _id = json["id"] as? Int, _id != 0,
        let k_sgryp = json["k_sgryp"] as? Int, k_sgryp != 0 else {
            return nil
//            throw ServiceError.WrongResponseFormat
        }
        
        id = _id
        fullName = json["fullname"] as? String
        groupTitle = json["grouptitle"] as? String
        studentType = json["studenttype"] as? String
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fullName = aDecoder.decodeObject(forKey: "fullName") as? String
        groupTitle = aDecoder.decodeObject(forKey: "groupTitle") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int ?? 0
        studentType = aDecoder.decodeObject(forKey: "studentType") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(fullName, forKey: "fullName")
        aCoder.encode(groupTitle, forKey: "groupTitle")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(studentType, forKey: "studentType")
    }

}
