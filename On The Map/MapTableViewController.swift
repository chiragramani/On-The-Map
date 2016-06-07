//
//  MapTableViewController.swift
//  On The Map
//
//  Created by Chirag Ramani on 03/06/16.
//  Copyright © 2016 Chirag Ramani. All rights reserved.
//

import Foundation
import UIKit

class MapTableViewController:UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    
    @IBOutlet weak var activityViewIndicator: UIActivityIndicatorView!
    @IBOutlet weak var myTableView: UITableView!
    let appDelegate=UIApplication.sharedApplication().delegate as! AppDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.locations.count
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell=myTableView.dequeueReusableCellWithIdentifier("CellId", forIndexPath: indexPath)
        
        let locationInfo = appDelegate.locations[indexPath.row]
        
        cell.textLabel?.text = locationInfo.firstName + " " + locationInfo.lastName
        cell.detailTextLabel?.text = locationInfo.mediaURL
        return cell
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        fetchContents()
        myTableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate=self
        activityViewIndicator.hidden=true
        
    }
    @IBAction func addLocationButtonPressed(sender: UIBarButtonItem) {
        PClient.sharedInstance().queryStudentLocation() { (success, error) in
            
            performUIUpdatesOnMain {
                if success {
                    
                    let nextVC = self.storyboard!.instantiateViewControllerWithIdentifier("FindOTM") as! FindOnTheMapViewController
                    nextVC.alreadyPosted = false
                    self.presentViewController(nextVC, animated: true, completion: nil)
                    
                } else {
                    if error == "Posted" {
                        let alert = UIAlertController(title: "", message: "You have already posted a location. Would you like to overwrite your current location?", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Overwrite", style: .Default, handler: { (action: UIAlertAction!) in
                            let nextVC = self.storyboard!.instantiateViewControllerWithIdentifier("FindOTM") as! FindOnTheMapViewController
                            nextVC.alreadyPosted = true
                            self.presentViewController(nextVC, animated: true, completion: nil)
                            
                        }))
                        
                        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                            return
                        }))
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    }
                    else{
                        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
            
            
        }
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let locationInfo = appDelegate.locations[indexPath.row]
        let url=NSURL(string: locationInfo.mediaURL)
        if(!UIApplication.sharedApplication().openURL(url!))
        {
            let alert=UIAlertController(title: "Eror", message: "Cannot open url", preferredStyle:.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
    
    
    @IBAction func refreshButtonPresse(sender: UIBarButtonItem) {
        
        fetchContents()
    }
    
    
    
    func fetchContents()->Void
    {
        
        activityViewIndicator.hidden=false
        activityViewIndicator.startAnimating()
        PClient.sharedInstance().getLocationInfoFromParse() { (success, error) in
            performUIUpdatesOnMain{
                if success {
                    self.myTableView.reloadData()
                    self.activityViewIndicator.hidden=true
                    self.activityViewIndicator.stopAnimating()
                } else {
                    if let error = error {
                        self.activityViewIndicator.stopAnimating()
                        self.activityViewIndicator.hidden=true
                        
                        let alert = UIAlertController(title: "", message: error, preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
                
            }
        }
        
        
        
    }
    
    
    @IBAction func logoutButtonPressed(sender: UIBarButtonItem) {
        activityViewIndicator.hidden=false
        activityViewIndicator.startAnimating()
        
        UClient.sharedInstance().deleteSession(){ (success, error) in
            performUIUpdatesOnMain{
                if success {
                    self.activityViewIndicator.hidden=true
                    self.activityViewIndicator.stopAnimating()
                    let nextVC=self.storyboard?.instantiateViewControllerWithIdentifier("loginVC") as! LoginViewController
                    self.presentViewController(nextVC, animated: true, completion: nil)
                    
                    
                } else {
                    if let error = error {
                        self.activityViewIndicator.stopAnimating()
                        self.activityViewIndicator.hidden=true
                        
                        let alert = UIAlertController(title: "Error", message: "Logout Failed", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
                
            }
        }
        
        
    }
    
    
    
}
