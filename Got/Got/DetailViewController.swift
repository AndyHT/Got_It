//
//  DetailViewController.swift
//  Got
//
//  Created by 一川 on 6/12/15.
//  Copyright © 2015 huoteng. All rights reserved.
//

import UIKit
import CoreLocation

class DetailViewController: UIViewController {
    
    var markedItemImage: UIImage? = nil
    var markedItemLocation: CLLocation? = nil

    @IBOutlet weak var markedItemTitle: UITextField!
    @IBOutlet weak var markedImageInView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let image = markedItemImage {
            markedImageInView.image = image
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveMarkedItem(sender: AnyObject) {
        //保存markedItem
        
    }

    
    

}
