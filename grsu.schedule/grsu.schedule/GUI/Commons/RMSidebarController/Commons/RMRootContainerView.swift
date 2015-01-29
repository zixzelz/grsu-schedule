//
//  RMRootСontainerView.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 1/29/15.
//  Copyright (c) 2015 Ruslan Maslouski. All rights reserved.
//

import UIKit

class RMRootContainerView: UIView {

    private var _holdFrame: Bool = false
    
    func holdFrame() {
        _holdFrame = true;
    }
    
    func releaseFrame() {
        _holdFrame = false;
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            if (!_holdFrame) {
                super.frame = newValue
            }
        }
    }
    
}
