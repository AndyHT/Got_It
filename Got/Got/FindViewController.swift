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
    
    var targetTitle:String? = nil
    var currentLocation:CLLocation? = nil
    var targetLocation:CLLocation? = nil
    var targetImageData:NSData? = nil
    
    @IBOutlet weak var currentDistanceLabel: UILabel!
    
    @IBOutlet weak var myAngle: UIImageView!
    
    @IBOutlet weak var targetPoint: UIImageView!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var targetImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let background = UIImage(named: "find-background")
//        if let back = background {
//            self.view.backgroundColor = UIColor(patternImage: back)
//        }
        
        locationManager.delegate = self
        // Do any additional setup after loading the view.
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if DeviceVersion().version >= 8 {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        print("location start update")
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.headingFilter = kCLHeadingFilterNone
        
        
        if let image = targetImageData {
            targetImage.image = UIImage(data: image)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
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
//            let currentAngle = Calculator().calculateAngle(tarLocation, currentLocation: curLocation)
//            print("current latitude: \(curLocation.coordinate.latitude), current longitude: \(curLocation.coordinate.longitude)")
//            print("target latitude: \(tarLocation.coordinate.latitude), target longitude: \(tarLocation.coordinate.longitude)")
//            print("current distance \(currentDistance)")
//            print("current angle \(currentAngle)")
            
            //显示当前距离
            distanceLabel.text = "\(currentDistance) M"
            if let title = targetTitle {
                currentDistanceLabel.text = "Distance from \(title):"
//                print(currentDistance)
            }
            
//            let radCurrentAngle = Calculator().rad(currentAngle)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //newHeading.trueHeading获得手机方向角,更改compass方向
        
        let direction = newHeading.trueHeading
        let angle = (direction.description as NSString).doubleValue
//        print("direction: \(direction), angle: \(angle)")
        
        let radAngle = Calculator().rad(angle);
        
        //指示我自己现在的方向
        self.myAngle.transform = CGAffineTransformMakeRotation(CGFloat(radAngle))
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func done(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

}
