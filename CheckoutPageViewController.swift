//
//  CheckoutPageViewController.swift
//  BikeCodingChallenge
//
//  Created by Annemarie Ketola on 7/14/15.
//  Copyright (c) 2015 Annemarie Ketola. All rights reserved.
//

import UIKit
import Parse

class CheckoutPageViewController: UIViewController {
    
    
    // theorietically we could use this bicycle data on this page to show what the user bought/is in his cart and populate that page
    var bicycleDataCheckout: PFObject!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    

    
}
