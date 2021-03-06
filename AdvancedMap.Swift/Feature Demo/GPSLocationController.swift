//
//  GPSLocationController.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 28/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class GPSLocationController : BaseController, CLLocationManagerDelegate, RotationDelegate {
    
    var contentView: GPSLocationView!
    
    var manager: CLLocationManager!
    
    var rotationListener: RotationListener!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView = GPSLocationView()
        view = contentView
        
        rotationListener = RotationListener()
        rotationListener?.map = contentView.map
        
        manager = CLLocationManager()
        manager.pausesLocationUpdatesAutomatically = false
        manager.desiredAccuracy = 1
        
        /*
         * In addition to requesting background location updates, you need to add the following lines to your Info.plist:
         *
         * 1. Privacy - Location When In Use Usage Description
         * 3. Required background modes:
         *    3.1 App registers for location updates
         */
        if #available(iOS 9.0, *) {
            manager.requestWhenInUseAuthorization()
        }
        
        contentView.addBanner(visible: true)
        let text = "Click the tracking icon if you wish to turn off tracking"
        contentView.banner.showInformation(text: text, autoclose: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.addRecognizers()
        
        manager.delegate = self
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
        
        contentView.map.setMapEventListener(rotationListener)
        rotationListener?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentView.removeRecognizers()
        
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
        manager.delegate = nil
        
        contentView.map.setMapEventListener(nil)
        rotationListener?.delegate = nil
    }
    
    var latestLocation: CLLocation!
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Latest location saved as class variable to get bearing to adjust compass
        latestLocation = locations[0]

        // Not "online", but reusing the online switch to achieve location tracking functionality
        if (contentView.switchButton.isOnline()) {
            contentView.locationMarker.showAt(location: latestLocation)
        }
    }

    func rotated(angle: CGFloat) {
        if (contentView.isRotationInProgress) {
            // Do not rotate when rotation reset animation is in progress
            return
        }
        contentView?.rotationResetButton.rotate(angle: angle)
    }
    
    func zoomed(zoom: CGFloat) {
        contentView?.scaleBar.update()
    }

}









