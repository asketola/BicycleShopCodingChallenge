//
//  ProductDetailsViewController.swift
//  BikeCodingChallenge
//
//  Created by Annemarie Ketola on 7/14/15.
//  Copyright (c) 2015 Annemarie Ketola. All rights reserved.
//

import UIKit
import Parse

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var brandNameText: UILabel!
    @IBOutlet weak var bicycleUIImage: UIImageView!
    @IBOutlet weak var bicycleModelText: UILabel!
    @IBOutlet weak var bicyclePriceText: UILabel!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    
    // the Parse object we passed from the previous view controller
    var bicycleData: PFObject!
    var bicycleDataImage: UIImage!
    
    // Activity spinner while we wait for Parse to add an item to the cart
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 105)) as UIActivityIndicatorView

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // loads our data from the Parse Object
        brandNameText.text = bicycleData["brandName"] as? String
        bicycleModelText.text = bicycleData["modelName"] as? String
        bicyclePriceText.text = bicycleData["price"] as? String
        productDescriptionTextView.text = bicycleData["description"] as? String
        bicycleUIImage.image = bicycleDataImage
        
        // Activity spinner while we wait for Parse to add our item to the cart
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        view.addSubview(self.actInd)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func addToCartButtonPressed(sender: AnyObject) {
        
        // starts the activity spinner
        self.actInd.startAnimating()
        
        // code to send the user's order to backend server in Parse as an object
        var currentUser = PFUser.currentUser()!
        var cartItem = PFObject(className: "Cart")
        cartItem["modelName"] = bicycleData["modelName"]
        cartItem["brandName"] = bicycleData["brandName"]
        cartItem["price"] = bicycleData["price"]
        cartItem["priceNumber"] = bicycleData["priceNumber"]
        cartItem["CheckedOut"] = false
        cartItem.setObject(currentUser, forKey: "user")
        cartItem.saveInBackgroundWithBlock { (Success: Bool, error: NSError?) -> Void in
            
            if error == nil {
                self.actInd.stopAnimating()
                println("Successfully added to cart in Parse")
                let checkoutAlertController = UIAlertController(title: "Congratulations!", message: "Your bike has been added to your cart", preferredStyle: .Alert)
                let shopAction = UIAlertAction(title: "Keep Shopping", style: UIAlertActionStyle.Default) { alertAction in self.performSegueWithIdentifier("BACK_TO_ALL_BIKES", sender: self)
                    // takes you back to all bikes page
                }
                let checkoutAction = UIAlertAction(title: "Check-out", style: UIAlertActionStyle.Cancel) { action in self.performSegueWithIdentifier("SHOW_CHECKOUT", sender: self)
                    // takes you to a checkout page
                }
                
                checkoutAlertController.addAction(shopAction)
                checkoutAlertController.addAction(checkoutAction)
                self.presentViewController(checkoutAlertController, animated: true, completion: nil)
            } else {
                // Alert the user that something went wrong with adding the item to the cart
                let errorAlertController = UIAlertController(title: "Error Saving to Cart", message: "Your item was not added to the cart. \n Error: \(error)", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                errorAlertController.addAction(OKAction)
                self.presentViewController(errorAlertController, animated: true, completion: nil)
            }
        }
   }
    
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            // manages the segues
            if segue.identifier == "BACK_TO_ALL_BIKES" {
                let detailedVC = segue.destinationViewController as! BicycleTableView
                // pass something here if necessary
            } else if segue.identifier == "SHOW_CHECKOUT" {
                let checkoutVC = segue.destinationViewController as! CheckoutPageViewController
                checkoutVC.bicycleDataCheckout = bicycleData
            } else if segue.identifier == "BACK_TO_BIKES" {
                let flipbackVC = segue.destinationViewController as! BicycleTableView
            }
        } // close override
}
