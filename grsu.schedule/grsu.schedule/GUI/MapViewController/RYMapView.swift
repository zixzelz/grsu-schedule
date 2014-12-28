//
//  MapView.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/27/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

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
        
        mapView = GMSMapView()//.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        mapView.settings.rotateGestures = false
        mapView.delegate = self
        
        mapView.setTranslatesAutoresizingMaskIntoConstraints(false)
        hostingMapView.addSubview(mapView)
        
        let viewDictionary = ["mapView": mapView];
        hostingMapView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[mapView]|", options: .AlignAllLeft, metrics: nil, views: viewDictionary))
        hostingMapView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[mapView]|", options: .AlignAllLeft, metrics: nil, views: viewDictionary))
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
            camera = GMSCameraUpdate.fitBounds(coordinateBounds, withEdgeInsets: mapInsets)
        } else {
            camera = GMSCameraUpdate.setTarget(currentLocation, zoom: 8)
        }
        
        if let cam = camera {
            mapView.animateWithCameraUpdate(cam)
        }
    }
    
    // MARK: - CalloutView

    func calloutView(forMarker: GMSMarker) -> UIView {
        return UIView()
    }
    
    func bottomOffsetForCalloutView() -> CGFloat {
        return 10
    }
    
    func showCalloutView(view: UIView, forMarker: GMSMarker) {
        calloutView_ = view
        updateCalloutViewPodition(forMarker)
        
        view.alpha = 0.0
        mapView.addSubview(view)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            view.alpha = 1.0
        })
    }
    
    func hideCalloutView() {
        mapView.selectedMarker = nil
        
        if let calloutView = calloutView_ {
            UIView.animateWithDuration(0.3, animations: { [weak self] _ in
                if let wself = self {
                    calloutView.alpha = 0.0
                }
            }) { [weak self] (animated: Bool) -> Void in
                if let wself = self {
                    calloutView.removeFromSuperview()
                }
            }
            calloutView_ = nil
        }
    }
    
    func updateCalloutViewPodition(forMarker: GMSMarker) {
        let anchor = forMarker.position
        var anchorPoint = mapView.projection.pointForCoordinate(anchor)
        
        let offset = bottomOffsetForCalloutView()
        anchorPoint.y -= offset
        
        calloutView_?.center = anchorPoint
    }

    // MARK: - RYBaseMapViewProtocol

    func reloadMarkersList() {
        hideCalloutView()
        
        let count = mapViewDataSource.numberOfMarkers()
        
        var tempMarkers = [GMSMarker]()
        for (var i = 0; i < count; i++) {
            var marker = GMSMarker()
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
    
    func selectMarker(index: Int) {
        if let markers = markers {
            let marker = markers[index]
            mapView.selectedMarker = marker
            
            let camera = GMSCameraUpdate.setTarget(marker.position)
            mapView.animateWithCameraUpdate(camera)
        }
    }
    
    // MARK: - GMSMapViewDelegate

    func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
        let view = calloutView(marker)
        showCalloutView(view, forMarker: marker)
        return UIView(frame: CGRectZero)
    }

    func mapView(mapView: GMSMapView!, didChangeCameraPosition position: GMSCameraPosition!) {
        if calloutView_ != nil && mapView.selectedMarker != nil {
            updateCalloutViewPodition(mapView.selectedMarker)
        }
    }
    
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        hideCalloutView()
    }
    
}
