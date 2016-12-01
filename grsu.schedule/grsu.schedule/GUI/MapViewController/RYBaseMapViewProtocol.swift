//
//  BaseMapViewProtocol.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/27/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit
import CoreLocation

@objc(RYBaseMapViewProtocol)
protocol RYBaseMapViewProtocol: NSObjectProtocol {
   
    func reloadMarkersList()
    func selectMarker(index: Int)
}

@objc(RYBaseMapViewDataSource)
protocol RYBaseMapViewDataSource: NSObjectProtocol {
    
    func initialLocation() -> CLLocationCoordinate2D
    func currentLocation() -> CLLocationCoordinate2D
    
    func numberOfMarkers() -> Int
    func locationForMarker(index: Int) -> CLLocationCoordinate2D
    func iconForMarker(index: Int) -> UIImage?
    
}
