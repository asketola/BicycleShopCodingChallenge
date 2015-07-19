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
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 105)) as UIActivityIndicatorView
    var keyboardHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.openingMountainBikeImage.alpha = 0
        self.bicycleShopNameText.alpha = 0
        self.usernameTextField.alpha = 0
        self.passwordTextField.alpha = 0
        self.loginButton.alpha = 0
        
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        view.addSubview(self.actInd)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        UIView.animateWithDuration(2.0, animations: { () -> Void in
            self.openingMountainBikeImage.alpha = 1.0
            self.bicycleShopNameText.alpha = 1.0
            self.usernameTextField.alpha = 1.0
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
        var username = self.usernameTextField.text
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
                    println("We had success logging in")
                    var alertSuccess = UIAlertController(title: "Success", message: "Logged In", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { alertAction in self.performSegueWithIdentifier("SHOW_BIKES_FOR_SALE", sender: self)
                    })
//                    let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)

                    alertSuccess.addAction(OKAction)
                    self.presentViewController(alertSuccess, animated: true, completion: nil)
                } else {
                    var alertFail = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertFail.addAction(OKAction)
                    self.presentViewController(alertFail, animated: true, completion: nil)
                } // close else
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SHOW_BIKES_FOR_SALE" {
            let bikesForSaleVC = segue.destinationViewController as! BicycleTableView
        }
    }
    
    
// MARK: Code for Keyboard mitigation
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        }else {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                keyboardHeight = keyboardSize.height
                self.animateTextField(true)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.animateTextField(false)
    }
    
    func animateTextField(up: Bool) {
        var movement = (up ? -keyboardHeight : keyboardHeight)
        
        UIView.animateWithDuration(0.3, animations: {
            self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        })
    }


}

