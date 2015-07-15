//
//  ViewController.swift
//  BikeCodingChallenge
//
//  Created by Annemarie Ketola on 7/13/15.
//  Copyright (c) 2015 Annemarie Ketola. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    @IBOutlet weak var bicycleShopNameText: UILabel!
    @IBOutlet weak var openingMountainBikeImage: UIImageView!
    @IBOutlet weak var usernameTextFIeld: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 105)) as UIActivityIndicatorView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.openingMountainBikeImage.alpha = 0
        self.bicycleShopNameText.alpha = 0
        self.usernameTextFIeld.alpha = 0
        self.passwordTextField.alpha = 0
        self.loginButton.alpha = 0
        
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        view.addSubview(self.actInd)
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
        // code to send login to Parse servers
        var username = self.usernameTextFIeld.text
        var password = self.passwordTextField.text
        
        if (count(username.utf16) < 4 || count(password.utf16) < 5) {
            
            var alert = UIAlertController(title: "Invalid", message: "Username must be greater than 4 and Password must be greater than 5.", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(OKAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            self.actInd.startAnimating()
            PFUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) -> Void in
                self.actInd.stopAnimating()
                if ((user) != nil) {
                    var alert = UIAlertController(title: "Success", message: "Logged In", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(OKAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    var alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(OKAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                } // close else
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SHOW_BIKES_FOR_SALE" {
            let bikesForSaleVC = segue.destinationViewController as! BicycleTableView
        }
    }
    
//    func keyboardWasShown(notification: NSNotification) {
//        var info = notification.userInfo!
//        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
//        
//        UIView.animateWithDuration(0.1, animations: { () -> Void in
//        self.bottomConstraint.constant = keyboardFrame.size.height + 100
//        })
//    }

}

