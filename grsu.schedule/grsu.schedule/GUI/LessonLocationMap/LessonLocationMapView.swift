//
//  LessonLocationMapView.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/27/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit
import GoogleMaps

class LessonLocationMapView: RYMapView {

    @IBOutlet weak var lessonLocationDataSource: LessonLocationMapViewDataSource!

    lazy var calloutView: CalloutView = {
        return Bundle.main.loadNibNamed("CalloutView", owner: self, options: nil)!.first as! CalloutView
    }()

    // MARK: - CalloutView
    
    override func bottomOffsetForCalloutView() -> CGFloat {
        return 74
    }

    override func calloutView(_ forMarker: GMSMarker) -> UIView {

        if let str = forMarker.userData as? String, let index = Int(str) {
            calloutView.titleLabel.text = lessonLocationDataSource.titleForMarker(index)
            calloutView.imageView.image = lessonLocationDataSource.imageForMarker(index)
        }

        return calloutView
    }

}
