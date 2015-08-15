//
//  ViewController.swift
//  BikeCodingChallenge
//
//  Created by Annemarie Ketola on 7/13/15.
//  Copyright (c) 2015 Annemarie Ketola. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var bicycleShopNameText: UILabel!
    @IBOutlet weak var openingMountainBikeImage: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    // Activity spinner while we wait for Parse to check login
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 105)) as UIActivityIndicatorView
    
    // For keyboard management
    var keyboardHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For the opening misty-styled animation loading
        self.openingMountainBikeImage.alpha = 0
        self.bicycleShopNameText.alpha = 0
        self.usernameTextField.alpha = 0
        self.passwordTextField.alpha = 0
        self.loginButton.alpha = 0
        self.signUpButton.alpha = 0
        
        // Activity spinner while we wait for Parse to check login
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        view.addSubview(self.actInd)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // For keyboard management
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        // For the opening misty-styled animation loading
        UIView.animateWithDuration(2.0, animations: { () -> Void in
            self.openingMountainBikeImage.alpha = 1.0
            self.bicycleShopNameText.alpha = 1.0
            self.usernameTextField.alpha = 1.0
            self.passwordTextField.alpha = 1.0
            self.loginButton.alpha = 1.0
            self.signUpButton.alpha = 1.0
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func loginButtonPressed(sender: AnyObject) {
        // Code to send the user's login info to the Parse servers
        var username = self.usernameTextField.text
        var password = self.passwordTextField.text
        
        if (count(username.utf16) < 4 || count(password.utf16) < 5) {
            // Alert to notify the user there was a login failure (too short inputs)
            usernamePasswordAlertController()
            
        } else {
            // Starts the activity spinner
            self.actInd.startAnimating()
            PFUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) -> Void in
                self.actInd.stopAnimating()
                if ((user) != nil) {
                    println("We had success logging in")
                    self.performSegueWithIdentifier("SHOW_BIKES_FOR_SALE", sender: self)
                } else {
                    // Alert to notify the user there was a login failure (incorrect username or password)
                    println("Why did we get to this alert")
                    var alertFail = UIAlertController(title: "Error", message: "The username or password is incorrect", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertFail.addAction(OKAction)
                    self.presentViewController(alertFail, animated: true, completion: nil)
                }
            })
        }
    }
    
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        // Code to send the user's login info to the Parse servers
        var user = PFUser()
        user.username = self.usernameTextField.text
        user.password = self.passwordTextField.text
        
        println("We got to the signUpButtonPressed")
        
        if (count(user.username!.utf16) < 4 || count(user.password!.utf16) < 5) {
            // Alert to notify the user there was a login failure (too short inputs)
             println("We got to the signUpButtonPressed error alert")
            usernamePasswordAlertController()
        } else {
            // Starts the activity spinner
            self.actInd.startAnimating()
            user.signUpInBackgroundWithBlock({ (succeeded: Bool, signupError: NSError?) -> Void in
                self.actInd.stopAnimating()
                
                if succeeded == true {
                    println("new user signed-up")
                    self.performSegueWithIdentifier("SHOW_BIKES_FOR_SALE", sender: self)
                } else {
                    // Alert to notify the user there was a sign-up failure (incorrect username or password)
                    var alertFail = UIAlertController(title: "Error", message: "Sign-up Faiure. \n Please try again \n \(signupError)", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertFail.addAction(OKAction)
                    self.presentViewController(alertFail, animated: true, completion: nil)
                    }
                })
            }
    } // close the signUpButtonPressed
    
    func usernamePasswordAlertController() {
            // Alert to notify the user there was a login failure (too short inputs)
            var alert = UIAlertController(title: "Invalid", message: "Username must be greater than 4 and Password must be greater than 5.", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(OKAction)
            self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SHOW_BIKES_FOR_SALE" {
            let bikesForSaleVC = segue.destinationViewController as! BicycleTableView
        }
    }
    
    
// MARK: Code for Keyboard management
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Releases the keyboard when you hit return or moves it to the next textField
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        }else {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        // Releases the keyboard if the user touches outside the textfields or keyboard
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        // Assigns the keyboard height and initiates the animation
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                keyboardHeight = keyboardSize.height
                self.animateTextField(true)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        // Lowers the texfields
        self.animateTextField(false)
    }
    
    func animateTextField(up: Bool) {
        // Animates the texFields to move up/down to make room for the keyboard
        var movement = (up ? -keyboardHeight : keyboardHeight)
        UIView.animateWithDuration(0.3, animations: {
            self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        })
    }


}

