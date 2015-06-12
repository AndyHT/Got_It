//
//  FindTableViewController.swift
//  Got
//
//  Created by 一川 on 6/12/15.
//  Copyright © 2015 huoteng. All rights reserved.
//

import UIKit

var finds:[FindModel] = []

class FindTableViewController: UITableViewController {

    @IBOutlet var findTableView: UITableView!
    
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
        
        finds = [FindModel(title: "Bicycle", date: dateFromString("2015-06-10"), latitude: 30.0, longitude: 100.0),
            FindModel(title: "5'th Coffee", date: dateFromString("2015-05-30"), latitude: 30.0, longitude: 110.0),
            FindModel(title: "Library", date: dateFromString("2015-05-30"), latitude: 30.0, longitude: 111.0),
            FindModel(title: "Hotel", date: dateFromString("2015-05-29"), latitude: 30.9, longitude: 111.1)]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
        return finds.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.findTableView.dequeueReusableCellWithIdentifier("findCell")! as UITableViewCell

        let find = finds[indexPath.row]
        let title = cell.viewWithTag(101) as! UILabel
        let date = cell.viewWithTag(102) as! UILabel
        
        title.text = find.title
        
        let locale = NSLocale.currentLocale()
        let dateFormat = NSDateFormatter.dateFormatFromTemplate("yyyy-MM-dd", options: 0, locale: locale)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
        date.text = dateFormatter.stringFromDate(find.date)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
