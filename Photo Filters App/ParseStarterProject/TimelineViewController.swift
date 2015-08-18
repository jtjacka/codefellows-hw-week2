//
//  TimelineViewController.swift
//  
//
//  Created by Jeffrey Jacka on 8/14/15.
//
//

import UIKit
import Parse


class TimelineViewController: UIViewController {

    //Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //Properties
    var timelineData : [(PFFile, String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        //Grab Timeline Info from Parse
        ParseService.downloadPostInfoFromParse{ (imagesFromParse) -> Void in
            if let imageData = imagesFromParse {
                self.timelineData = imageData
                self.tableView.reloadData()
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

//MARK: Extend UITableViewDatasource
extension TimelineViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timelineData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCell", forIndexPath: indexPath) as! TimelineCell
      
        //Proper way to use a tuple?
        ParseService.downloadImagesFromParse(timelineData[indexPath.row].0, completion: { (imageReturn) -> Void in
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            cell.timelineImage?.image = imageReturn
          })
        })
      
        cell.userComment?.text = timelineData[indexPath.row].1
        
        return cell
    }
}
