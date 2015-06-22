//
//  MarkViewController.swift
//  Got
//
//  Created by 一川 on 6/12/15.
//  Copyright © 2015 huoteng. All rights reserved.
//

import UIKit
import CoreLocation

class MarkViewController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var loading: UILabel!
    
    @IBOutlet weak var markBtn: UIButton!
    
    @IBOutlet weak var cameraView: UIImageView!
    
    @IBOutlet weak var confirmPhoto: UIButton!
    
    let locationManager:CLLocationManager = CLLocationManager()
    let picker = UIImagePickerController()
    
    var currentLocations: CLLocation? = nil
    var pickedImage: UIImage? = nil
    
    var isTookPhoto = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        markBtn.hidden = true
        confirmPhoto.hidden = true
        loadingIndicator.startAnimating()
        locationManager.delegate = self
        picker.delegate = self
                
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if DeviceVersion().version >= 8 {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.startUpdatingLocation()
        print("lcoation start update")
        
        //设置Filter每秒钟获取一次位置
        locationManager.distanceFilter = kCLDistanceFilterNone
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.navigationBarHidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if isTookPhoto {
            //添加动画
            UIView.animateWithDuration(0.5, animations: {
                self.markBtn.center.x = CGFloat(65)
                self.markBtn.center.y = CGFloat(503)
                
                self.confirmPhoto.alpha = 0.8
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
        let location:CLLocation = locations[locations.count - 1] as! CLLocation
        print("get current location")
        //if location changed, update currentLocations
        if (location.horizontalAccuracy > 0) {
            
            currentLocations = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            setViewAfterGetLocationSuccess()

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
        
        }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //将照片和位置信息传给DetailView
        if segue.identifier == "markedItem" {
            let detailView = segue.destinationViewController as! DetailViewController
            
            if let location = currentLocations, let image = pickedImage {
                detailView.markedItemImage = image
                print(image.description)
                detailView.markedItemLocation = location
            }
        }
        
    }
    
    
    //拍照并记录coordinate,将coordinate传给DetailViewController
    @IBAction func markIt(sender: AnyObject) {
        if let location = currentLocations {
            print("latitude:\(location.coordinate.latitude),longitude:\(location.coordinate.longitude)")
            locationManager.stopUpdatingLocation()
            
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                picker.allowsEditing = false
                picker.sourceType = UIImagePickerControllerSourceType.Camera
                picker.cameraCaptureMode = .Photo
                presentViewController(picker, animated: true, completion: nil)
                
                
            } else {
                noCamera()
                
            }
        }
    }
    
    func noCamera() {
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style:.Default, handler: nil)
        alertVC.addAction(okAction)
        presentViewController(alertVC, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        var chosenImage: UIImage
        
        if picker.allowsEditing {
            chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        } else {
            chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        }
//        self.saveImage(chosenImage, newSize: CGSize(width: 256, height: 256), percent: 0.5, imageName: "currentImage.png")
        cameraView.contentMode = .ScaleAspectFit
        cameraView.hidden = false
        cameraView.image = chosenImage
        pickedImage = chosenImage
        confirmPhoto.hidden = false
        confirmPhoto.alpha = 0
        
        isTookPhoto = true
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
