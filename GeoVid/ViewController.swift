//
//  ViewController.swift
//  GeoVid
//
//  Created by Aaron Batchelder on 3/3/17.
//  Copyright © 2017 Aaron Batchelder. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    private var previousPoint: CLLocation?
    private var totalMovementDistance: CLLocationDistance = 0
    
    @IBOutlet var latitudeLabel:UILabel!
    @IBOutlet var longitudeLabel:UILabel!
    @IBOutlet var horizontalAccuracyLabel:UILabel!
    @IBOutlet var altitudeLabel:UILabel!
    @IBOutlet var verticalAccuracyLabel:UILabel!
    @IBOutlet var distanceTraveledLabel:UILabel!
    
    
    // Delegate Methods
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        print("Authorization status changed to \(status.rawValue)")
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            
        default:
            locationManager.stopUpdatingLocation()
        }
    }

    
    func locationManager(_ manager: CLLocationManager,
                                 didFailWithError error: NSError!) {
        let errorType = error.code == CLError.denied.rawValue
                        ? "Access Denied": "Error \(error.code)"
        
        let alertController = UIAlertController(title: "Location Manager Error", message: errorType, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: {action in})
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let newLocation = (locations as [CLLocation])[locations.count - 1]
        
        let latitudeString = String(format: "%g\u{00B0}", newLocation.coordinate.latitude)
        let longitudeString = String(format: "%g\u{00B0}", newLocation.coordinate.longitude)
        let horizontalAccuracyString = String(format:"%gm", newLocation.horizontalAccuracy)
        let verticalAccuracyString = String(format:"%gm", newLocation.verticalAccuracy)
        let altitudeString = String(format:"%gm",newLocation.altitude)
        
        print(latitudeString)
        
        latitudeLabel.text = latitudeString
        longitudeLabel.text = longitudeString
        horizontalAccuracyLabel.text = horizontalAccuracyString
        verticalAccuracyLabel.text = verticalAccuracyString
        altitudeLabel.text = altitudeString
        
        if newLocation.horizontalAccuracy < 0 {
            //invalid accuracy
            return
        }
        
        if newLocation.horizontalAccuracy > 100 || newLocation.verticalAccuracy > 50 {
            // accuracy radius too large to use
            return
        }
        
        if previousPoint == nil {
            totalMovementDistance = 0
        } else {
            print("movement distance: " +
                "\(newLocation.distance(from: previousPoint!))")
            
            totalMovementDistance += newLocation.distance(from: previousPoint!)
        }
        previousPoint = newLocation
        
        let distanceString = String(format: "%gm", totalMovementDistance)
        distanceTraveledLabel.text = distanceString
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

