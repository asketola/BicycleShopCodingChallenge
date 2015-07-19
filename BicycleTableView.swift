//
//  BicycleTableView.swift
//  BikeCodingChallenge
//
//  Created by Annemarie Ketola on 7/14/15.
//  Copyright (c) 2015 Annemarie Ketola. All rights reserved.
//

import UIKit
import Parse

class BicycleTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var storeNameText: UILabel!
    @IBOutlet weak var storeBikeTypeLabel: UILabel!
    
    @IBOutlet weak var typesOfBikesTableView: UITableView!
    
    var bicycleObjects: NSMutableArray! = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllObjects()
        
        self.storeNameText.alpha = 0
        self.storeBikeTypeLabel.alpha = 0
        self.typesOfBikesTableView.alpha = 0
        
        var nib = UINib(nibName: "BicycleTableViewCell", bundle: nil)
        typesOfBikesTableView.registerNib(nib, forCellReuseIdentifier: "cell")
        
        self.typesOfBikesTableView.rowHeight = 120.0

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
        self.storeNameText.alpha = 1.0
        self.storeBikeTypeLabel.alpha = 1.0
        self.typesOfBikesTableView.alpha = 1.0
        })
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bicycleObjects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:BicycleTableViewCell = self.typesOfBikesTableView.dequeueReusableCellWithIdentifier("cell") as! BicycleTableViewCell
        
        var object: PFObject = self.bicycleObjects.objectAtIndex(indexPath.row) as! PFObject
        println("from cellforRowAtIndexPath object: \(object)")
        
        cell.bikeBrandNameText!.text = object["brandName"] as? String
        cell.bikeModelText!.text = object["modelName"] as? String
        cell.bikepriceText!.text = object["price"] as? String
        
        let bikePicture = object["bikeImage"] as! PFFile
        bikePicture.getDataInBackgroundWithBlock { (imageData, error) -> Void in
            if (error == nil) {
                let image = UIImage(data:imageData!)
                cell.bikeImage.image = image
            }
        }
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected a cell #\(indexPath.row)!")
        performSegueWithIdentifier("SHOW_BIKE_DETAIL", sender: self)
    }
    
    
    func fetchAllObjects() {
        //        PFObject.unpinAllObjectsInBackgroundWithBlock(nil)
        var query: PFQuery = PFQuery(className: "Bicycle")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if error == nil {
                var temp: NSArray = objects as AnyObject! as! NSArray
                self.bicycleObjects = temp.mutableCopy() as! NSMutableArray
                self.typesOfBikesTableView.reloadData()
                
            }
            
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("We got to the prepare for Segue")
            if segue.identifier == "SHOW_BIKE_DETAIL" {
                
            let indexPath = self.typesOfBikesTableView.indexPathForSelectedRow()!
            var object: PFObject = self.bicycleObjects.objectAtIndex(indexPath.row) as! PFObject
            let detailedVC = segue.destinationViewController as! ProductDetailsViewController
            detailedVC.bicycleData = object
      }
    }


}
