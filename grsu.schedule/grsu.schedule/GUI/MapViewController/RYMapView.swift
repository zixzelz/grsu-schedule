//
//  MapView.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/27/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit
import GoogleMaps

class RYMapView: UIView, RYBaseMapViewProtocol, GMSMapViewDelegate {

    @IBOutlet weak var mapViewDataSource: RYBaseMapViewDataSource!

    @IBOutlet weak var hostingMapView: UIView!
    var mapView: GMSMapView!
    var markers: [GMSMarker]?
    var calloutView_: UIView?

    override func awakeFromNib() {
        super.awakeFromNib()

        setupMapView()
    }

    func setupMapView() {
//        let location = mapViewDataSource.initialLocation()
//        let camera = GMSCameraPosition.cameraWithTarget(location, zoom: 8)

        mapView = GMSMapView() // .mapWithFrame(CGRectZero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.rotateGestures = false
        mapView.delegate = self

        mapView.translatesAutoresizingMaskIntoConstraints = false
        hostingMapView.addSubview(mapView)

        let viewDictionary: [String: UIView] = ["mapView": mapView];
        hostingMapView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mapView]|", options: .alignAllLeft, metrics: nil, views: viewDictionary))
        hostingMapView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[mapView]|", options: .alignAllLeft, metrics: nil, views: viewDictionary))
    }

    func applyZoomForMarkers() {

        var camera: GMSCameraUpdate?

        let currentLocation = self.mapViewDataSource.currentLocation()
        if (currentLocation.latitude == 0 && currentLocation.longitude == 0) {
            var coordinateBounds = GMSCoordinateBounds()
            for marker in markers! {
                coordinateBounds = coordinateBounds.includingCoordinate(marker.position)
            }

            let mapInsets = UIEdgeInsetsMake(70.0, 20, 0.0, 20)
            camera = GMSCameraUpdate.fit(coordinateBounds, with: mapInsets)
        } else {
            camera = GMSCameraUpdate.setTarget(currentLocation, zoom: 8)
        }

        if let cam = camera {
            mapView.animate(with: cam)
        }
    }

    // MARK: - CalloutView

    func calloutView(_ forMarker: GMSMarker) -> UIView {
        return UIView()
    }

    func bottomOffsetForCalloutView() -> CGFloat {
        return 10
    }

    func showCalloutView(_ view: UIView, forMarker: GMSMarker) {
        calloutView_ = view
        updateCalloutViewPodition(forMarker)

        view.alpha = 0.0
        mapView.addSubview(view)
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            view.alpha = 1.0
        })
    }

    func hideCalloutView() {
        mapView.selectedMarker = nil

        if let calloutView = calloutView_ {
            UIView.animate(withDuration: 0.3, animations: {

                calloutView.alpha = 0.0
            }, completion: { (animated: Bool) -> Void in

                calloutView.removeFromSuperview()
            }) 
            calloutView_ = nil
        }
    }

    func updateCalloutViewPodition(_ forMarker: GMSMarker) {
        let anchor = forMarker.position
        var anchorPoint = mapView.projection.point(for: anchor)

        let offset = bottomOffsetForCalloutView()
        anchorPoint.y -= offset

        calloutView_?.center = anchorPoint
    }

    // MARK: - RYBaseMapViewProtocol

    func reloadMarkersList() {
        hideCalloutView()

        let count = mapViewDataSource.numberOfMarkers()

        var tempMarkers = [GMSMarker]()
        for i in 0 ..< count {

            let marker = GMSMarker()
            marker.userData = "\(i)"
            marker.position = mapViewDataSource.locationForMarker(i)
            marker.appearAnimation = kGMSMarkerAnimationPop
            marker.icon = mapViewDataSource.iconForMarker(i)
            marker.map = mapView

            tempMarkers.append(marker)
        }
        markers = tempMarkers
        applyZoomForMarkers()
    }

    func selectMarker(_ index: Int) {
        if let markers = markers {
            let marker = markers[index]
            mapView.selectedMarker = marker

            let camera = GMSCameraUpdate.setTarget(marker.position)
            mapView.animate(with: camera)
        }
    }

    // MARK: - GMSMapViewDelegate

    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {

        if let markers = markers,
            let index = markers.index(of: marker) {
            mapViewDataSource.didSelectMarker(index)
        }

        let view = calloutView(marker)
        showCalloutView(view, forMarker: marker)
        return UIView(frame: CGRect.zero)
    }

    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {

        if let selectedMarker = mapView.selectedMarker, calloutView_ != nil {
            updateCalloutViewPodition(selectedMarker)
        }
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        mapViewDataSource.didDeselectMarker()
        hideCalloutView()
    }

}
