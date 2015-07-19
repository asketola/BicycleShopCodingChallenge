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
    
    var bicycleData: PFObject!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        brandNameText.text = bicycleData["brandName"] as? String
        bicycleModelText.text = bicycleData["modelName"] as? String
        bicyclePriceText.text = bicycleData["price"] as? String
        productDescriptionTextView.text = bicycleData["description"] as? String
        let bikeImageUIimage = bicycleData["image"] as! String
        let bikeImageUIimage1 = UIImage(named: bikeImageUIimage)
        bicycleUIImage.image = bikeImageUIimage1
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func addToCartButtonPressed(sender: AnyObject) {
        
        // code to send order to backend server in Parse
        var cartItem = PFObject(className: "Cart")
        cartItem["modelName"] = bicycleData["modelName"]
        cartItem["brandName"] = bicycleData["brandName"]
        //        cartItem["username"] = PFUser.currentUser()
        cartItem["price"] = bicycleData["price"]
        cartItem.saveInBackgroundWithBlock { (Success: Bool, error: NSError?) -> Void in
            
            if error == nil {
                println("Successfully added to cart in Parse")
                let checkoutAlertController = UIAlertController(title: "Congratulations!", message: "Your bike has been added to your cart", preferredStyle: .Alert)
                let shopAction = UIAlertAction(title: "Keep Shopping", style: UIAlertActionStyle.Default) { alertAction in self.performSegueWithIdentifier("BACK_TO_ALL_BIKES", sender: self)
                    // should take you back to all bikes page
                    println("cancel button pressed")
                }
                let checkoutAction = UIAlertAction(title: "Check-out", style: UIAlertActionStyle.Cancel) { action in self.performSegueWithIdentifier("SHOW_CHECKOUT", sender: self)
                    // should take you to a checkout page
                    println("ok action button pressed")
                }
                
                checkoutAlertController.addAction(shopAction)
                checkoutAlertController.addAction(checkoutAction)
                self.presentViewController(checkoutAlertController, animated: true, completion: nil)
            } else {
                let errorAlertController = UIAlertController(title: "Error Saving to Cart", message: "Error: \(error)", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                errorAlertController.addAction(OKAction)
                self.presentViewController(errorAlertController, animated: true, completion: nil)
            }
        }
   }
    
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            println("We got here")
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
