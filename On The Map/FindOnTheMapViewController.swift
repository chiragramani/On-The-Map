//
//  FindOnTheMapViewController.swift
//  On The Map
//
//  Created by Chirag Ramani on 03/06/16.
//  Copyright © 2016 Chirag Ramani. All rights reserved.
//


import UIKit
import MapKit

class FindOnTheMapViewController:UIViewController,MKMapViewDelegate,UITextFieldDelegate
{
    
    @IBOutlet weak var activityViewIndicator: UIActivityIndicatorView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var topView: UIView!
    var alreadyPosted:Bool!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var middleVIew: UIView!
    @IBOutlet weak var findButton: UIButton!
    
    var searchResults = [MKMapItem]()
    var resultName:String = ""
    var locCoordinates:CLLocationCoordinate2D!
    
    @IBOutlet weak var myMapView: MKMapView!
    
    @IBOutlet weak var bottpmView: UIView!
    
    @IBAction func findButtonPressed(sender: UIButton) {
        
        if (sender.titleLabel?.text == "Find On The Map")
        {
            if(locationTextField.text=="")
            {
                displayErrorInUI("Please enter the location")
            }
            else
            {
                activityViewIndicator.hidden=false
                activityViewIndicator.startAnimating()
                searchQueryTest(locationTextField.text!)
            }
        }
        else
        {
            if(topTextField.text=="" || topTextField.text=="Enter a link to share here ")
            {
                displayErrorInUI("Please enter the link")
                topTextField.text="Enter a link to share here "
            }
            else
            {
                postLink(alreadyPosted!)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityViewIndicator.hidden=true
        topTextField.delegate=self
        configureUI(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        configureUI(true)
    }
    
    
    func displayErrorInUI(string : String) -> Void
    {
        performUIUpdatesOnMain{
            self.activityViewIndicator.hidden=true
            self.activityViewIndicator.stopAnimating()
            let alert=UIAlertController(title: "Error ", message: string, preferredStyle: UIAlertControllerStyle.Alert);
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: nil));
            
            self.presentViewController(alert, animated: true, completion: nil);
        }
        
    }
    
    func searchQueryTest(location:String)->Void
    {
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = location
        
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler({(response,
            error) in
            
            if error != nil {
                self.displayErrorInUI((error?.localizedDescription)!)
                
            } else if response!.mapItems.count == 0 {
                self.displayErrorInUI("Sorry..Can't find location")
            } else {
                
                self.searchResults=response!.mapItems as [MKMapItem]
                self.resultName=self.searchResults[0].name!
                self.locCoordinates=self.searchResults[0].placemark.coordinate
                PClient.sharedInstance().latitude=self.locCoordinates.latitude
                PClient.sharedInstance().longitude=self.locCoordinates.longitude
                PClient.sharedInstance().mapString=self.resultName
                PClient.sharedInstance().mediaURL=self.topTextField.text
                print(self.resultName)
                print(self.locCoordinates)
                self.configureUI(false)
                self.mapToDisplay(self.locCoordinates, locationTitle: self.resultName)
                
            }
        })
    }
    
    func configureUI(bool:Bool)->Void
    {
        self.view.backgroundColor = bool ? UIColor.init(red: CGFloat(170.0/255.0), green: CGFloat(170.0/255.0), blue: CGFloat(170.0/255.0), alpha: CGFloat(1.0)) : UIColor.init(red: CGFloat(72.0/255.0), green: CGFloat(175.0/255.0), blue: CGFloat(231.0/255.0), alpha: CGFloat(1.0))
        
        topView.backgroundColor=bool ? UIColor.init(red: CGFloat(170.0/255.0), green: CGFloat(170.0/255.0), blue: CGFloat(170.0/255.0), alpha: CGFloat(170.0/255.0)) : UIColor.init(red: CGFloat(72.0/255.0), green: CGFloat(175.0/255.0), blue: CGFloat(231.0/255.0), alpha: CGFloat(1.0))
        bottpmView.backgroundColor = bool ? UIColor.init(red: CGFloat(170.0/255.0), green: CGFloat(170.0/255.0), blue: CGFloat(170.0/255.0), alpha: CGFloat(1.0))         : UIColor.clearColor()
        
        myMapView.hidden=bool ? true : false
        
        topTextField.text=bool ? "Where are you studying today?" : "Enter a link to share here "
        middleVIew.hidden=bool ? false: true
        locationTextField.placeholder="Enter your location here!"
        
        findButton.setTitle(bool ? "Find On The Map" : "Submit", forState:UIControlState.Normal)
        
        navigationBar.barTintColor=bool ? UIColor.init(red: CGFloat(170.0/255.0), green: CGFloat(170.0/255.0), blue: CGFloat(170.0/255.0), alpha: CGFloat(1.0)) : UIColor.init(red: CGFloat(72.0/255.0), green: CGFloat(175.0/255.0), blue: CGFloat(231.0/255.0), alpha: CGFloat(1.0))
        
    }
    
    func mapToDisplay(locationCoordinates:CLLocationCoordinate2D,locationTitle:String) ->Void
    {
        let latDelta:CLLocationDegrees=0.01
        let longDelta:CLLocationDegrees=0.01
        let span=MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let locRegion=MKCoordinateRegion(center: locationCoordinates, span: span)
        myMapView.setRegion(locRegion, animated: true)
        let locationAnnotation=MKPointAnnotation()
        locationAnnotation.coordinate=locationCoordinates
        locationAnnotation.title=locationTitle
        myMapView.addAnnotation(locationAnnotation)
        self.activityViewIndicator.hidden=true
        self.activityViewIndicator.stopAnimating()
    }
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if (textField.text=="Where are you studying today?")
        {
            return false
        }
        else
        {
            if (textField.text=="Enter a link to share here ")
            {
                textField.text=""
                return true
            }
            return true
        }
    }
    
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        
       dismissViewControllerAnimated(true, completion: nil)
    }
    
    func postLink(alreadyPosted:Bool)-> Void
    {
        
        if(alreadyPosted)
        {     print(self.topTextField.text!)
            PClient.sharedInstance().updateStudentLocation(self.topTextField.text!)
            {
                (success:Bool?,error:String?) -> Void in
                performUIUpdatesOnMain{
                    if let error=error
                    {
                        self.displayErrorInUI(error)
                    }
                    else
                    {
                        let viewController=self.storyboard?.instantiateViewControllerWithIdentifier("TabBarVC") as! UITabBarController
                        self.presentViewController(viewController, animated: true, completion: nil)
                    }
                    
                }}  }
        else {
            print(self.topTextField.text!)
            PClient.sharedInstance().postStudentLocation(self.topTextField.text!)
            {
                (success:Bool?,error:String?) -> Void in
                performUIUpdatesOnMain{
                    if let error=error
                    {
                        self.displayErrorInUI(error)
                    }
                    else
                    {
                        let viewController=self.storyboard?.instantiateViewControllerWithIdentifier("TabBarVC") as! UITabBarController
                        self.presentViewController(viewController, animated: true, completion: nil)
                    }
                }}
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}


