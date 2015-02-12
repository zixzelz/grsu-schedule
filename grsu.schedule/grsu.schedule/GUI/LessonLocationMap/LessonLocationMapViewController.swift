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
    var initAddress_: String?
    
    var initAddress: String? {
        get { return initAddress_ }
        set (aNewValue) {
            if let val = aNewValue {
                initAddress_ = AddressUtils.restoreAddress(val)
            } else {
                initAddress_ = nil
            }
        }
    }
    
//    init(initAddress: String) {
//        super.init()
//        self.initAddress = AddressUtils.restoreAddress(initAddress)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.fetchData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        Flurry.logEvent("Lesson Location Map")
    }

    func fetchData() {
        GetUniversityBuildings.getBuildings() { [weak self](universityBuildings: [UniversityBuilding]?, error: NSError?) -> Void in
            if let wSelf = self {
                if let universityBuildings = universityBuildings {
                    wSelf.universityBuildings = universityBuildings
                    wSelf.ownView().reloadMarkersList()
                }
                if let address = wSelf.initAddress {
                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
                    dispatch_after(delayTime, dispatch_get_main_queue()) {
                        wSelf.selectMarker(address)
                    }
                }
            }
        }
    }
    
    func selectMarker(address: String) {
        if let universityBuildings = universityBuildings {
            let foundItems = universityBuildings.filter { $0.address?.rangeOfString(address, options: .CaseInsensitiveSearch, range: nil, locale: nil) != nil }
            let foundItem = foundItems.first
            
            if let universityBuilding = foundItem {
                let index = find(universityBuildings, universityBuilding)!
                ownView().selectMarker(index)
            } else {
                //TODO find location via google services
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
