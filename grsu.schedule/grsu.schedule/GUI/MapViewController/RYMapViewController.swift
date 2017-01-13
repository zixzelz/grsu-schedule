//
//  MapViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/27/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit
import CoreLocation

class RYMapViewController: UIViewController, RYBaseMapViewDataSource {
    
    // MARK: - RYBaseMapViewDataSource

    func initialLocation() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }

    func numberOfMarkers() -> Int {
        return 0
    }

    func locationForMarker(index: Int) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }

    func iconForMarker(index: Int) -> UIImage? {
        return nil
    }

    func currentLocation() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }

    func didSelectMarker(index: Int) {}
    func didDeselectMarker() {}
}
