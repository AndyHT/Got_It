//
//  DetailViewController.swift
//  Got
//
//  Created by 一川 on 6/12/15.
//  Copyright © 2015 huoteng. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class DetailViewController: UIViewController, UITextFieldDelegate {
    
    var markedItemImage: UIImage? = nil
    var markedItemLocation: CLLocation? = nil
    
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate


    @IBOutlet weak var markedItemTitle: UITextField!
    @IBOutlet weak var markedImageInView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        markedItemTitle.placeholder = "请输入图片的名字"
        markedItemTitle.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: CGFloat(0.5))

        markedItemTitle.delegate = self
        // Do any additional setup after loading the view.
        if let image = markedItemImage {
            markedImageInView.image = image
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        markedItemTitle.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func saveMarkedItem(sender: AnyObject) {
        
        if let needSaveTitle = markedItemTitle.text, let needSaveLocation = markedItemLocation, let needSaveImage = markedImageInView.image {
            //保存markedItem
            self.saveMarkedItemInCoreData(needSaveTitle, location: needSaveLocation, image: needSaveImage)
            self.navigationController?.popToRootViewControllerAnimated(true)

        } else {
            //提示用户需要拍照和输入title
            let alert = UIAlertController(title: "没有照片或者title", message: "请拍摄照片或输入title", preferredStyle: .Alert)
            
            let confirmAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            
            alert.addAction(confirmAction)
            
            presentViewController(alert, animated: true, completion: nil)
            
        }
        
    }

    func saveMarkedItemInCoreData(markedTitle: String, location: CLLocation, image: UIImage) {
        
        
        //保存数据到Coredata
        let managedContext = self.appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Coordinates",
            inManagedObjectContext: managedContext)
        
        if let entityGot = entity {
            let markedItem = NSManagedObject(entity: entityGot, insertIntoManagedObjectContext:managedContext)
            
            let tempDate = NSDate()
            let tempLatitude = location.coordinate.latitude
            let tempLongitude = location.coordinate.longitude
            markedItem.setValue(markedTitle, forKey: "id")
            markedItem.setValue(tempDate, forKey: "time")
            markedItem.setValue(tempLatitude, forKey: "latitude")
            markedItem.setValue(tempLongitude, forKey: "longitude")
            
            //保存图片到沙盒
//            if let image = markedItemImage {
//                self.saveImage(image, newSize: CGSize(width: 40, height: 40), percent: 0.5, imageName: "\(markedTitle)-\(tempDate)")
//            }
            
            do {
                try managedContext.save()
            } catch {
                print("Could not save with error")
            }
        }
        
    }

    
    //保存图片至沙盒
    func saveImage(currentImage: UIImage, newSize: CGSize, percent: CGFloat, imageName: String){
        //压缩图片尺寸
        UIGraphicsBeginImageContext(newSize)
        currentImage.drawInRect(CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //高保真压缩图片质量
        //UIImageJPEGRepresentation此方法可将图片压缩，但是图片质量基本不变，第二个参数即图片质量参数。
        let imageData: NSData = UIImageJPEGRepresentation(newImage, percent)!
        // 获取沙盒目录,这里将图片放在沙盒的documents文件夹中
        let fullPath: String = NSHomeDirectory().stringByAppendingPathComponent("Documents").stringByAppendingPathComponent(imageName)
        // 将图片写入文件
        imageData.writeToFile(fullPath, atomically: false)
    }
}
