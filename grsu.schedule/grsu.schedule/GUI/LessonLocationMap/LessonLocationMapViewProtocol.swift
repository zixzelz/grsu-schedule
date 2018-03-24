//
//  LessonLocationMapViewProtocol.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/27/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

@objc(LessonLocationMapViewProtocol)
protocol LessonLocationMapViewProtocol: NSObjectProtocol {
   
}

@objc(LessonLocationMapViewDataSource)
protocol LessonLocationMapViewDataSource: NSObjectProtocol {
    
    func titleForMarker(_ index: Int) -> String
    func imageForMarker(_ index: Int) -> UIImage?
    
}
