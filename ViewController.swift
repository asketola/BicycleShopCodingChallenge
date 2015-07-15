//
//  ViewController.swift
//  BikeCodingChallenge
//
//  Created by Annemarie Ketola on 7/13/15.
//  Copyright (c) 2015 Annemarie Ketola. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bicycleShopNameText: UILabel!
    @IBOutlet weak var openingMountainBikeImage: UIImageView!
    @IBOutlet weak var usernameTextFIeld: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonPressed(sender: AnyObject) {
        // code to servers to login
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SHOW_BIKES_FOR_SALE" {
            
            
            
            
            
            let bikesForSaleVC = segue.destinationViewController as! BicycleTableView
        }
    }

}

