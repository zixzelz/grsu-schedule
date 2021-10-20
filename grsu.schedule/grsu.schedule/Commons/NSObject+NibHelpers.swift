//
//  NSObjectNibExtensions.swift
//  BuddyHOPP
//
//  Created by andrei.pitsko on 21.12.14.
//  Copyright (c) 2014 Buddyhopp SA. All rights reserved.
//

import UIKit

extension NSObject {
    
    @objc class func loadNibForClass() -> UINib {
        var classString = NSStringFromClass(self.classForCoder())
        let rangeOfNamespaceDot = classString.range(of: ".")
        
        if let strongRangeOfNamespaceDot = rangeOfNamespaceDot {
            classString = String(classString[classString.index(after: strongRangeOfNamespaceDot.lowerBound) ..< classString.endIndex])
        }
        
        return UINib(nibName: classString, bundle: nil)
    }
    
    class func firstObjectFromClassNib<T>() -> T? {
        return self.firstObjectFromClassNibWithOwner(nil)
    }
    
    class func firstObjectFromClassNibWithOwner<T>(_ owner:Any?) -> T? {
        return self.loadNibForClass().instantiate(withOwner: owner, options: nil).first as? T
    }
}
