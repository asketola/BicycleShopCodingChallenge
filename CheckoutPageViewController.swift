//
//  CheckoutPageViewController.swift
//  BikeCodingChallenge
//
//  Created by Annemarie Ketola on 7/14/15.
//  Copyright (c) 2015 Annemarie Ketola. All rights reserved.
//

import UIKit
import Parse
import Bolts

class CheckoutPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var CheckoutLabel: UILabel!
    @IBOutlet weak var itemsinCartLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    
    @IBOutlet weak var itemsInCartTableView: UITableView!

    // to show what the user bought/is in his cart and populate the page
    var bicycleDataCheckout: PFObject!
    var cartObjects: NSMutableArray! = NSMutableArray()
    var bicycleSumArray: [Int] = Array()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllCartItems()
        addUpSum()
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
        // add up the sum of the items in the person's cart and set the Label with the formatted number
        var sumPrice = bicycleSumArray.reduce(0,combine: +)
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        var formattedSumPrice = numberFormatter.stringFromNumber(sumPrice)!
        self.totalPriceLabel!.text = "Total: $\(formattedSumPrice)"
    }
    
    func bicycleSoldParseUpdate() {
        // get the number of items in the user's cart
        var numberOfItemsInCart = cartObjects.count - 1
        
        // get the objectID of each item
        for object in cartObjects{
            for i in 0...numberOfItemsInCart {
        var object: PFObject = self.cartObjects.objectAtIndex(i) as! PFObject
                var objectID: String = object.objectId!
                
        // save to the backend that the items have been purchased, updating that column
        var query = PFQuery(className: "Cart")
                query.getObjectInBackgroundWithId("\(objectID)", block: { (cart: PFObject?, error: NSError?) -> Void in
                    if error != nil {
                        println("error \(error)")
                    } else if let cart = cart {
                        cart["CheckedOut"] = true
                        cart.saveInBackground()
                    }
                })
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
        
        // could add ApplePay here - perhaps future addition
        // ApplePay code
        
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
