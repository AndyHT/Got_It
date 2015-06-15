//
//  MarkViewController.swift
//  Got
//
//  Created by 一川 on 6/12/15.
//  Copyright © 2015 huoteng. All rights reserved.
//

import UIKit
import CoreLocation

class MarkViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var loading: UILabel!
    
    @IBOutlet weak var markBtn: UIButton!
    
    @IBOutlet weak var cameraView: UIImageView!
    
    let locationManager:CLLocationManager = CLLocationManager()
    
    var currentLocations:[CLLocation] = []
    var isFirstGetCoordinate = true

    override func viewDidLoad() {
        super.viewDidLoad()
        markBtn.hidden = true
        loadingIndicator.startAnimating()
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let deviceVersion = DeviceVersion()
        
        if deviceVersion.version >= 8 {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.startUpdatingLocation()
        
        //设置Filter每秒钟获取一次位置
        locationManager.distanceFilter = kCLDistanceFilterNone
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ios8() -> Bool {
        let version = UIDevice.currentDevice().systemVersion
        let ver = NSNumberFormatter().numberFromString(version)!.floatValue
        return ver >= 8.0
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
        let location:CLLocation = locations[locations.count - 1] as! CLLocation
        
        //if location changed, update currentLocations
        if (location.horizontalAccuracy > 0) {
            
            //可以考虑将currentLocation设置为optional
            
            //如果是第一次得到Coordinate, 此时currentLocations还是空数组
            if isFirstGetCoordinate {
                setViewAfterGetLocationSuccess()
                isFirstGetCoordinate = false
                currentLocations.append(CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))

            }
            //为了优化数据结构大小
            currentLocations[0] = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
        
        self.cameraView.hidden = true
        self.markBtn.hidden = true
        
        self.loading.text = "无法得到位置信息"
        self.loading.hidden = false
    }
    
    func setViewAfterGetLocationSuccess() {
        self.loadingIndicator.hidden = true
        self.loadingIndicator.stopAnimating()
        self.loading.hidden = true
        
        markBtn.hidden = false
        
        //temp for test
        let image = UIImage(named: "test_image")
        self.cameraView.image = image
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //拍照并记录coordinate,将coordinate传给DetailViewController
    @IBAction func markIt(sender: AnyObject) {
        let location = currentLocations[0]
        print("latitude:\(location.coordinate.latitude),longitude:\(location.coordinate.longitude)")
        locationManager.stopUpdatingLocation()
    }
    

}
