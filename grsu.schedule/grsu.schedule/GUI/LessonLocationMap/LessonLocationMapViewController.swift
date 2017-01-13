//
//  LessonLocationMapViewController.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/25/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit
import CoreLocation
import Flurry_iOS_SDK

class LessonLocationMapViewController: RYMapViewController, LessonLocationMapViewDataSource, CLLocationManagerDelegate {

    @IBOutlet var routeButton: UIBarButtonItem!

    var universityBuildings: [UniversityBuilding]?
    var initAddress_: String?

    private var selectedUniversityBuildingIndex: Int? {
        didSet {
            routeButton.enabled = (selectedUniversityBuildingIndex != nil)
        }
    }

    let locationManager = CLLocationManager()

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

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

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

            if let universityBuilding = foundItems.first {

                let index = universityBuildings.indexOf(universityBuilding)
                ownView().selectMarker(index!)
            } else {
                showMessage("Адрес не найден")
                // TODO find location via google services
            }
        }
    }

    func ownView() -> RYBaseMapViewProtocol {
        return self.view as! RYBaseMapViewProtocol
    }

    @IBAction func routeButtonPressed() {

        guard let mainLocation = locationManager.location?.coordinate else {
            showMessage("Failed to detect location")
            return
        }

        guard let index = selectedUniversityBuildingIndex else { return }
        let universityBuilding = universityBuildings![index]
        let location = universityBuilding.location!

        let urlStr = "yandexmaps://maps.yandex.ru/?rtext=\(mainLocation.latitude),\(mainLocation.longitude)~\(location.latitude),\(location.longitude)"
        guard let url = NSURL(string: urlStr) else {
            showMessage("Адрес не найден")
            return
        }

        guard let urlForCheck = NSURL(string: "yandexmaps://") else { return }
        if UIApplication.sharedApplication().canOpenURL(urlForCheck) {
            UIApplication.sharedApplication().openURL(url)
        } else {
            guard let appUrl = NSURL(string: "https://itunes.apple.com/ru/app/yandex.maps/id313877526?mt=8") else { return }
            UIApplication.sharedApplication().openURL(appUrl)
            showMessage("Приложение Яндекс.Карты не установлено")
        }
    }

    private func showMessage(title: String) {

        let alert = UIAlertController(title: title, message: "", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))

        presentViewController(alert, animated: true, completion: nil)
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

    override func didSelectMarker(index: Int) {
        selectedUniversityBuildingIndex = index
    }

    override func didDeselectMarker() {
        selectedUniversityBuildingIndex = nil
    }

    // MARK: - LessonLocationMapViewDataSource

    func titleForMarker(index: Int) -> String {

        let universityBuilding = universityBuildings![index]
        var title = ""

        if universityBuilding is EducationalUniversityBuilding {

            let educationalUniversityBuilding = universityBuilding as! EducationalUniversityBuilding

            let titles = educationalUniversityBuilding.faculties!.map { $0.title! } as [String]
            title = titles.joinWithSeparator("\n")
        } else {

            let educationalUniversityBuilding = universityBuilding as! HostelUniversityBuilding
            title = "Общежитие №\(educationalUniversityBuilding.number!)"
        }

        return title
    }

    func imageForMarker(index: Int) -> UIImage? {
        let universityBuilding = universityBuildings![index]

        return UIImage(named: universityBuilding.photo!)
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        manager.stopUpdatingLocation()
    }

}
