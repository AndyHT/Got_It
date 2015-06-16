//
//  FindViewController.swift
//  Got
//
//  Created by 一川 on 6/15/15.
//  Copyright © 2015 huoteng. All rights reserved.
//

import UIKit
import CoreLocation

class FindViewController: UIViewController, CLLocationManagerDelegate {
    
    
    let locationManager:CLLocationManager = CLLocationManager()
    
    var currentLocation:CLLocation? = nil
    var targetLocation:CLLocation? = nil
    
    @IBOutlet weak var currentDistanceLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        // Do any additional setup after loading the view.
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if DeviceVersion().version >= 8 {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.startUpdatingLocation()
        print("location start update")
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
        print("get location")
        let location: CLLocation = locations[locations.count - 1] as! CLLocation
        
        if location.horizontalAccuracy > 0 {
            currentLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
        
        //得到targetLocation，计算角度和距离，用动画改变View
        if let tarLocation = targetLocation, let curLocation = currentLocation {
            let currentDistance = Calculator().calculateDistance(tarLocation, currentLocation: curLocation)
            print("current latitude: \(curLocation.coordinate.latitude), current longitude: \(curLocation.coordinate.longitude)")
            print("target latitude: \(tarLocation.coordinate.latitude), target longitude: \(tarLocation.coordinate.longitude)")
            print("current distance \(currentDistance)")
            currentDistanceLabel.text = "\(currentDistance)"
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
