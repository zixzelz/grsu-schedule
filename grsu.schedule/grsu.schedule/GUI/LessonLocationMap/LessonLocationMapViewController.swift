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

    fileprivate var selectedUniversityBuildingIndex: Int? {
        didSet {
            routeButton.isEnabled = (selectedUniversityBuildingIndex != nil)
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

        let delayTime = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.fetchData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
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
                    let delayTime = DispatchTime.now() + 1
                    DispatchQueue.main.asyncAfter(deadline: delayTime) {
                        wSelf.selectMarker(address)
                    }
                }
            }
        }
    }

    func selectMarker(_ address: String) {

        if let universityBuildings = universityBuildings {

            let foundItems = universityBuildings.filter { $0.address?.range(of: address, options: .caseInsensitive, range: nil, locale: nil) != nil }

            if let universityBuilding = foundItems.first {

                let index = universityBuildings.index(of: universityBuilding)
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

        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse {

            let alertController = UIAlertController (title: "Приложение не знает, где вы находитесь", message: "Разрешите приложению определить ваше местоположение: это делается в настройках устройства.", preferredStyle: .alert)

            let settingsAction = UIAlertAction(title: "Настройки", style: .default) { (_) -> Void in
                let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.shared.openURL(url)
                }
            }

            let cancelAction = UIAlertAction(title: "Отменить", style: .default, handler: nil)
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)

            present(alertController, animated: true, completion: nil)
            return
        }

        guard let mainLocation = locationManager.location?.coordinate else {
            showMessage("Failed to detect location")
            return
        }

        guard let index = selectedUniversityBuildingIndex else { return }
        let universityBuilding = universityBuildings![index]
        let location = universityBuilding.location!

        let urlStr = "yandexmaps://maps.yandex.ru/?rtext=\(mainLocation.latitude),\(mainLocation.longitude)~\(location.latitude),\(location.longitude)"
        guard let url = URL(string: urlStr) else {
            showMessage("Адрес не найден")
            return
        }

        guard let urlForCheck = URL(string: "yandexmaps://") else { return }
        if UIApplication.shared.canOpenURL(urlForCheck) {
            UIApplication.shared.openURL(url)
            Flurry.logEvent("route with yandex maps")
        } else {
            
            let alertController = UIAlertController (title: "Приложение Яндекс.Карты не установлено", message: "Нажмите кнопку Установить для установки", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "Установить", style: .default) { (_) -> Void in
                let settingsUrl = URL(string: "https://itunes.apple.com/ru/app/yandex.maps/id313877526?mt=8")
                if let url = settingsUrl {
                    UIApplication.shared.openURL(url)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Отменить", style: .default, handler: nil)
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }

    fileprivate func showMessage(_ title: String) {

        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    // MARK: - RYBaseMapViewDataSource

    override func numberOfMarkers() -> Int {
        return universityBuildings != nil ? universityBuildings!.count : 0
    }

    override func locationForMarker(_ index: Int) -> CLLocationCoordinate2D {
        return universityBuildings![index].location!
    }

    override func iconForMarker(_ index: Int) -> UIImage? {
        let universityBuilding = universityBuildings![index]
        var image: UIImage?

        if universityBuilding is EducationalUniversityBuilding {
            image = UIImage(named: "EducationalMapMarker")
        } else {
            image = UIImage(named: "HostelMapMarker")
        }

        return image
    }

    override func didSelectMarker(_ index: Int) {
        selectedUniversityBuildingIndex = index
    }

    override func didDeselectMarker() {
        selectedUniversityBuildingIndex = nil
    }

    // MARK: - LessonLocationMapViewDataSource

    func titleForMarker(_ index: Int) -> String {

        let universityBuilding = universityBuildings![index]
        var title = ""

        if universityBuilding is EducationalUniversityBuilding {

            let educationalUniversityBuilding = universityBuilding as! EducationalUniversityBuilding

            let titles = educationalUniversityBuilding.faculties!.map { $0.title! } as [String]
            title = titles.joined(separator: "\n")
        } else {

            let educationalUniversityBuilding = universityBuilding as! HostelUniversityBuilding
            title = "Общежитие №\(educationalUniversityBuilding.number!)"
        }

        return title
    }

    func imageForMarker(_ index: Int) -> UIImage? {
        let universityBuilding = universityBuildings![index]

        return UIImage(named: universityBuilding.photo!)
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        manager.stopUpdatingLocation()
    }

}
