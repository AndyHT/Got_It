//
//  FindListTableViewController.swift
//  Got
//
//  Created by 一川 on 6/11/15.
//  Copyright © 2015 huoteng. All rights reserved.
//

import UIKit
import CoreLocation


//使用finds代替Core Data存储list cell
var finds: [FindModel] = []

class FindListTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var findListTableView: UITableView!
    
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
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return finds.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.findListTableView.dequeueReusableCellWithIdentifier("findCell")! as UITableViewCell
        let title = cell.viewWithTag(101) as! UILabel
        let date = cell.viewWithTag(102) as! UILabel
        
        let find:FindModel
        
        let locale = NSLocale.currentLocale()
        let dateFormat = NSDateFormatter.dateFormatFromTemplate("yyyy-MM-dd", options: 0, locale: locale)
        
        title.text = find.title
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
        date.text = dateFormatter.stringFromDate(find.date)
        
        return cell
    }


}
