//
//  LessonLocationMapViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/25/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class LessonLocationMapViewController: RYMapViewController, LessonLocationMapViewDataSource {

    var universityBuildings : [UniversityBuilding]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.fetchData()
        }
    }
    
    func fetchData() {
        GetUniversityBuildings.getBuildings() { [weak self](universityBuildings: [UniversityBuilding]?, error: NSError?) -> Void in
            if let wSelf = self {
                if let universityBuildings = universityBuildings {
                    wSelf.universityBuildings = universityBuildings
                    wSelf.ownView().reloadMarkersList()
                }
            }
        }
    }
    
    func ownView() -> RYBaseMapViewProtocol {
        return self.view as RYBaseMapViewProtocol
    }

    // MARK: - RYBaseMapViewDataSource
    
    override func numberOfMarkers() -> Int {
        return universityBuildings != nil ? universityBuildings!.count : 0
    }
    
    override func locationForMarker(index: Int) -> CLLocationCoordinate2D {
        return universityBuildings![index].location!
    }

    override func iconForMarker(index: Int) -> UIImage? {
        let universityBuilding = universityBuildings![index]
        var image: UIImage?
        
        if universityBuilding is EducationalUniversityBuilding {
            image = UIImage(named: "EducationalMapMarker")
        } else {
            image = UIImage(named: "HostelMapMarker")
        }

        return image
    }

    // MARK: - LessonLocationMapViewDataSource
   
    func titleForMarker(index: Int) -> String {
        let universityBuilding = universityBuildings![index]
        var title = ""
        
        if universityBuilding is EducationalUniversityBuilding {
            let educationalUniversityBuilding = universityBuilding as EducationalUniversityBuilding
            
            let titles = educationalUniversityBuilding.faculties!.map { $0.title! } as [String]
            title = join("\n", titles)
        } else {
            let educationalUniversityBuilding = universityBuilding as HostelUniversityBuilding
            title = "Общежитие №\(educationalUniversityBuilding.number!)"
        }
        
        return title
    }
    
    func imageForMarker(index: Int) -> UIImage? {
        let universityBuilding = universityBuildings![index]
        
        return UIImage(named: universityBuilding.photo!)
    }

}
