//
//  GuidePageViewController.swift
//  Got
//
//  Created by 一川 on 6/16/15.
//  Copyright © 2015 huoteng. All rights reserved.
//

import UIKit

class GuidePageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var images = ["guideImage1", "guideImage2", "guideImage3"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let startingViewController = self.viewControllerAtIndex(0) {
            setViewControllers([startingViewController], direction: .Forward, animated: true, completion: nil)
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! GuideContentViewController).index
        
        index--
        
        return self.viewControllerAtIndex(index)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! GuideContentViewController).index
        
        index++
        
        return self.viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index: Int) -> GuideContentViewController? {
        
        if index == NSNotFound || index < 0 || index >= self.images.count {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        if let contentView = storyboard?.instantiateViewControllerWithIdentifier("GuideContentViewController") as? GuideContentViewController {
            
            contentView.imageName = images[index]
            contentView.index = index
            
            return contentView
        }
        
        return nil
    }
    
}
