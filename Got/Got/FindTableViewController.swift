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
//    var targetLocation: CLLocation? = nil
    
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
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let managedContext = self.appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Coordinates")
        
        //3
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
        
        title.text = markItem.valueForKey("id") as! String?
        
        //当读到没有date的数据时代码会crash
        let locale = NSLocale.currentLocale()
        let dateFormat = NSDateFormatter.dateFormatFromTemplate("yyyy-MM-dd", options: 0, locale: locale)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
        let markDate = markItem.valueForKey("time") as! NSDate//添加viewWillAppear就会导致crash
        
        date.text = dateFormatter.stringFromDate(markDate)

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

//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let selectedRow = indexPath.row
//        let selectedItem = markedItemsArray[selectedRow]
//        let latitude = selectedItem.valueForKey("latitude") as! CLLocationDegrees
//        let longitude = selectedItem.valueForKey("longitude") as! CLLocationDegrees
//        
//        targetLocation = CLLocation(latitude: latitude, longitude: longitude)
//    }
    
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
        }
    }
    

    @IBAction func addCoordinate(sender: AnyObject) {
        let alert = UIAlertController(title: "New name",
            message: "Add a new name",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default) { (action: UIAlertAction!) -> Void in
                
                let textField = alert.textFields![0] as UITextField
                self.saveMarkedItemInCoreData(textField.text!)
                self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
    }
    
    func saveMarkedItemInCoreData(id: String) {
        //1
        let managedContext = self.appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("Coordinates",
            inManagedObjectContext: managedContext)
        
        if let entityGot = entity {
            let markedItem = NSManagedObject(entity: entityGot, insertIntoManagedObjectContext:managedContext)

            //3
            let tempDate = dateFromString("2015-06-10")
            let tempLatitude = 30.0
            let tempLongitude = 110.0
            markedItem.setValue(id, forKey: "id")
            markedItem.setValue(tempDate, forKey: "time")
            markedItem.setValue(tempLatitude, forKey: "latitude")
            markedItem.setValue(tempLongitude, forKey: "longitude")
            
            //4
            do {
                try managedContext.save()
            } catch {
                print("Could not save with error")
            }
            //5
            markedItemsArray.append(markedItem)
        }
    }
}
