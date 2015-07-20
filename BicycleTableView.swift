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
    
    // Holds all the bike objects we get from the backend server Parse
    var bicycleObjects: NSMutableArray! = NSMutableArray()
    var bicycleImages: NSMutableArray! = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllBikes()
        
        // For the misty-styled animation loading
        self.storeNameText.alpha = 0
        self.storeBikeTypeLabel.alpha = 0
        self.typesOfBikesTableView.alpha = 0
        
        // For our custom cell
        var nib = UINib(nibName: "BicycleTableViewCell", bundle: nil)
        typesOfBikesTableView.registerNib(nib, forCellReuseIdentifier: "cell")
        
        self.typesOfBikesTableView.rowHeight = 120.0

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // For the misty-styled animation loading
        UIView.animateWithDuration(1.0, animations: { () -> Void in
        self.storeNameText.alpha = 1.0
        self.storeBikeTypeLabel.alpha = 1.0
        self.typesOfBikesTableView.alpha = 1.0
        })
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bicycleObjects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:BicycleTableViewCell = self.typesOfBikesTableView.dequeueReusableCellWithIdentifier("cell") as! BicycleTableViewCell
        
        var object: PFObject = self.bicycleObjects.objectAtIndex(indexPath.row) as! PFObject
        
        cell.bikeBrandNameText!.text = object["brandName"] as? String
        cell.bikeModelText!.text = object["modelName"] as? String
        cell.bikepriceText!.text = object["price"] as? String
        
        // Placeholder bike to show while the images load
        let bikeImageUIimage = "bike-20clip-20art-yioe4EMpT.png"
        let bikeImageUIimage1 = UIImage(named: bikeImageUIimage)
        cell.bikeImage.image = bikeImageUIimage1
        
        // Lazily load the images in the cells
        let bikePicture = object["bikeImage"] as! PFFile
        bikePicture.getDataInBackgroundWithBlock { (imageData, error) -> Void in
            if (error == nil) {
                let image = UIImage(data:imageData!)
                cell.bikeImage.image = image
                self.bicycleImages.addObject(image!)
            }
        }
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Lets the user go to a detailed description of the bike selected
        performSegueWithIdentifier("SHOW_BIKE_DETAIL", sender: self)
    }
    
    func fetchAllBikes() {
        // This is the query we send to Parse to get all the bikes that the shop sells
        var query: PFQuery = PFQuery(className: "Bicycle")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
        
            if error == nil {
                // Each bike is an object so we add the object to the global array we defined
                var temp: NSArray = objects as AnyObject! as! NSArray
                self.bicycleObjects = temp.mutableCopy() as! NSMutableArray
                
                // reloads the tableView with the new data
                self.typesOfBikesTableView.reloadData()
            }
        }
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if segue.identifier == "SHOW_BIKE_DETAIL" {
            let indexPath = self.typesOfBikesTableView.indexPathForSelectedRow()!
            var object: PFObject = self.bicycleObjects.objectAtIndex(indexPath.row) as! PFObject
            var objectImage: UIImage = self.bicycleImages.objectAtIndex(indexPath.row) as! UIImage
            let detailedVC = segue.destinationViewController as! ProductDetailsViewController
            detailedVC.bicycleData = object
            detailedVC.bicycleDataImage = objectImage
        }
    }


}
