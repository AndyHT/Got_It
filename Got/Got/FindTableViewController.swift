//
//  FindTableViewController.swift
//  Got
//
//  Created by 一川 on 6/12/15.
//  Copyright © 2015 huoteng. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class FindTableViewController: UITableViewController {

    @IBOutlet var findTableView: UITableView!
    var markedItemsArray = [NSManagedObject]()
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var targetLocation: CLLocation? = nil
    
    func dateFromString(dateStr: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.dateFromString(dateStr)
        return date!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationController!.navigationBar.alpha = 0.5
        
        let tableViewBackgroundImage = UIImage(named: "background")
        if let back = tableViewBackgroundImage {
            self.tableView.backgroundColor = UIColor(patternImage: back)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.navigationBarHidden = false
        
        let managedContext = self.appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName:"Coordinates")
        
        let fetchedResults:[AnyObject]
        
        do {
            try fetchedResults = managedContext.executeFetchRequest(fetchRequest)
            let results = fetchedResults as! [NSManagedObject]
            markedItemsArray = results
        } catch {
            print("Could not fetch \(error)")
        }
        
        findTableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //如果tableView第一次打开给用户提示
        let defaults = NSUserDefaults.standardUserDefaults()
        let isFirstOpen = defaults.boolForKey("isFirstOpen")
        if isFirstOpen {
            let alert = UIAlertController(title: "您的Marked List还没有任何东西", message: "点击右上角的＋试试～", preferredStyle: .Alert)
            let confirmAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            
            alert.addAction(confirmAction)
            
            presentViewController(alert, animated: true, completion: nil)
            defaults.setBool(false, forKey: "isFirstOpen")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return markedItemsArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.findTableView.dequeueReusableCellWithIdentifier("findCell")! as UITableViewCell

        let markItem = markedItemsArray[indexPath.row]
        
        let title = cell.viewWithTag(101) as! UILabel
        let date = cell.viewWithTag(102) as! UILabel
//        let imageInCell = cell.viewWithTag(103) as! UIImageView
        
        title.text = markItem.valueForKey("id") as! String?
        
        //需要从沙盒中取出图片
//        imageInCell.image = UIImage(named: "")
        
        //当读到没有date的数据时代码会crash
        let locale = NSLocale.currentLocale()
        let dateFormat = NSDateFormatter.dateFormatFromTemplate("yyyy-MM-dd", options: 0, locale: locale)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
        let markDate = markItem.valueForKey("time") as! NSDate
        
        date.text = dateFormatter.stringFromDate(markDate)
        
        cell.backgroundColor = UIColor(white: 1, alpha: CGFloat(0.5))

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let deletedItem = markedItemsArray.removeAtIndex(indexPath.row)
            
            //需要将数据库里的数据删除
            let managedContext = self.appDelegate.managedObjectContext
            managedContext.deleteObject(deletedItem)
            
            do {
                try managedContext.save()
            } catch {
                print("there is an error when deleted item")
            }
            
            self.findTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)

        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "TargetLocation" {
            let findView = segue.destinationViewController as! FindViewController
            let targetIndex = self.findTableView.indexPathForSelectedRow!.row
            let targetItem = markedItemsArray[targetIndex]
            let targetLatitude = targetItem.valueForKey("latitude") as! Double
            let targetLongitude = targetItem.valueForKey("longitude") as! Double
            findView.targetLocation = CLLocation(latitude: targetLatitude, longitude: targetLongitude)
            findView.targetTitle = targetItem.valueForKey("id") as? String
        }
    }
    
}
