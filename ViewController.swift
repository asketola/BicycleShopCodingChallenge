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
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.openingMountainBikeImage.alpha = 0
        self.bicycleShopNameText.alpha = 0
        self.usernameTextFIeld.alpha = 0
        self.passwordTextField.alpha = 0
        self.loginButton.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(2.0, animations: { () -> Void in
            self.openingMountainBikeImage.alpha = 1.0
            self.bicycleShopNameText.alpha = 1.0
            self.usernameTextFIeld.alpha = 1.0
            self.passwordTextField.alpha = 1.0
            self.loginButton.alpha = 1.0
        })
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

