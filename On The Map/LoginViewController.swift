//
//  ViewController.swift
//  On The Map
//
//  Created by Chirag Ramani on 30/05/16.
//  Copyright © 2016 Chirag Ramani. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController,UITextFieldDelegate {
    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var activityViewIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate=self
        passwordTextField.delegate=self
        activityViewIndicator.hidden=true
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        if ((emailTextField.text!.isEmpty) || (passwordTextField.text!.isEmpty))
        {
            let alert = UIAlertController(title: "Error", message: "Email or Password not entered" , preferredStyle:UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {   activityViewIndicator.hidden=false
            activityViewIndicator.startAnimating()
            login()
        }
    }
    
    func login()
    {
      
        UClient.sharedInstance().getSessionID(self.emailTextField.text!,password: self.passwordTextField.text!) { (success, error) -> Void in
            
            if success {
                
                UClient.sharedInstance().getPublicUserData()
                performUIUpdatesOnMain{
                    self.emailTextField.text=""
                    self.passwordTextField.text=""
                    self.activityViewIndicator.hidden=true
                    self.activityViewIndicator.stopAnimating()
                    self.performSegueWithIdentifier("tabBarSegue", sender: self)
                }
                
            } else {
                if let error = error {
                    print(error)
                }
                let alert = UIAlertController(title: "Error", message: error , preferredStyle:UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                performUIUpdatesOnMain{
                    self.activityViewIndicator.hidden=true
                    self.activityViewIndicator.stopAnimating()
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    @IBAction func signUpButtonPressed(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}


