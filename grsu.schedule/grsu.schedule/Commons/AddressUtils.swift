//
//  AddressUtils.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/28/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class AddressUtils: NSObject {
   
    class func restoreAddress(_ address: String) -> String  {
        
        let dict = [
            "Врубл.": "Врублевского",
            "БЛК": "Бульвар Ленинского Комсомола",
            "пер.": "переулок ",
            "Дзерж.": "Дзержинского",
        ]
        
        var str = address
        for (key, value) in dict {
            str = str.replacingOccurrences(of: key, with: value)
        }
        return str
    }
    
}
