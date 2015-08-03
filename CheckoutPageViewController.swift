//
//  CheckoutPageViewController.swift
//  BikeCodingChallenge
//
//  Created by Annemarie Ketola on 7/14/15.
//  Copyright (c) 2015 Annemarie Ketola. All rights reserved.
//

import UIKit
import Parse

class CheckoutPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var CheckoutLabel: UILabel!
    @IBOutlet weak var itemsinCartLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    
    @IBOutlet weak var itemsInCartTableView: UITableView!

    // theorietically we could use this bicycle data on this page to show what the user bought/is in his cart and populate that page
    var bicycleDataCheckout: PFObject!
    var cartObjects: NSMutableArray! = NSMutableArray()
    var bicycleSumArray: [Int] = Array()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllCartItems()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cartObjects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:checkoutCell = self.itemsInCartTableView.dequeueReusableCellWithIdentifier("cartCell") as! checkoutCell
        
        var object: PFObject = self.cartObjects.objectAtIndex(indexPath.row) as! PFObject
        
        cell.modelLabel!.text = object["modelName"] as? String
        cell.brandLabel!.text = object["brandName"] as? String
        cell.priceLabel!.text = object["price"] as? String
        
        self.bicycleSumArray.append(object["priceNumber"] as! Int)
        addUpSum()
        
        return cell
    }
    
    func loadAllCartItems() {
        // Query from Parse all the things in the cart
        // This is the query we send to Parse to get all the bikes that the user put in their cart
        var query: PFQuery = PFQuery(className: "Cart")
        var user = PFUser.currentUser()!
        query.whereKey("user", equalTo: user)
        query.whereKey("CheckedOut", equalTo: false)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                // Each bike is an object so we add the object to the global array we defined
//                println("Objects we got from the backend: \(objects)")
                var temp: NSArray = objects as AnyObject! as! NSArray
                self.cartObjects = temp.mutableCopy() as! NSMutableArray
                
                // reloads the tableView with the new data
                self.itemsInCartTableView.reloadData()
            }
        }
    }
    
    func addUpSum() {
        // add up the sum of the items in the person's cart and set the Label
        var sumPrice = bicycleSumArray.reduce(0,combine: +)
        self.totalPriceLabel!.text = "Total: $\(sumPrice)"
    }
    
    func bicycleSoldParseUpdate() {
        
        var query: PFQuery = PFQuery(className: "Cart")
        var user = PFUser.currentUser()!
        query.whereKey("user", equalTo: user)
        query.whereKey("CheckedOut", equalTo: false)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
//                println("Success")
            } else {
                // Sets bool to false, so that items bought won't show back up in the cart next time
//                var object: PFObject
//                for object in objects {
//                    object["CheckedOut"] =  true as Bool
//                    object.saveInBackground
//                    }
                }
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logoutParseUser(sender: AnyObject) {
        // theoretically the user would logout after they checked out
        PFUser.logOut()
        println("We logged out the user")
    }
    

    @IBAction func CheckoutButtonPressed(sender: AnyObject) {
        // Clear the cart
        bicycleSoldParseUpdate()
        
        // hide the checkout button to prevent the user from re-buying the product
        self.checkoutButton.hidden = true
        
        // Alert to notify the user their items have been bought
        var alert = UIAlertController(title: "Items Purchased!", message: "Congratulations! \n You are the proud new owner of a Santa Cruz Bicycle!", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        let checkoutAction = UIAlertAction(title: "Logout?", style: .Default) { action in self.performSegueWithIdentifier("SHOW_LOGIN", sender: self)
        PFUser.logOut()
        println("We logged out the user")
        }
        alert.addAction(checkoutAction)
        alert.addAction(OKAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }


    @IBAction func backToShoppingButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("KEEP_SHOPPING", sender: self)
    }
    
}
