//
//  GuideContentViewController.swift
//  Got
//
//  Created by 一川 on 6/16/15.
//  Copyright © 2015 huoteng. All rights reserved.
//

import UIKit

class GuideContentViewController: UIViewController {
    
    var imageName = ""
    var index = 0
    
    @IBOutlet weak var backImage: UIImageView!
    
    @IBOutlet weak var getStartButton: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.currentPage = index
        // Do any additional setup after loading the view.
        
        backImage.image = UIImage(named: imageName)
        
        getStartButton.hidden = (index == 2) ? false : true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func closeGuideView(sender: AnyObject) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "hasViewedWalkthrough")
        
        defaults.setBool(true, forKey: "isFirstOpen")
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
