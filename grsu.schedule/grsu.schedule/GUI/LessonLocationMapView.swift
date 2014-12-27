//
//  LessonLocationMapView.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/27/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class LessonLocationMapView: RYMapView {

    // MARK: - CalloutView

    override func calloutView(forMarker: GMSMarker) -> UIView {
        let view = UIView(frame: CGRectMake(0, 0, 100, 50))
        view.backgroundColor = UIColor.blueColor()
        return view
    }

}
