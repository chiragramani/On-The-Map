//
//  MapViewController.swift
//  On The Map
//
//  Created by Chirag Ramani on 03/06/16.
//  Copyright © 2016 Chirag Ramani. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController:UIViewController,MKMapViewDelegate
{
    
    @IBOutlet weak var activityViewIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var myMapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myMapView.delegate=self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        fetchContents()
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func loadDataToMap() {
        var annotations = [MKPointAnnotation]()
        for locationInfo in PClient.sharedInstance().locations {
            let lat = CLLocationDegrees(locationInfo.latitude)
            let long = CLLocationDegrees(locationInfo.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let first = locationInfo.firstName
            let last = locationInfo.lastName
            let mediaUrl = locationInfo.mediaURL
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaUrl
            annotations.append(annotation)
        }
        self.myMapView.addAnnotations(annotations)
        activityViewIndicator.stopAnimating()
        activityViewIndicator.hidden=true
        myMapView.alpha=CGFloat(1.0)
    }
    
    
    @IBAction func mapPinButtonPressed(sender: AnyObject) {
        
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
                }
            }
        }
    }
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
    
    
    @IBAction func refreshButtonPressed(sender: UIBarButtonItem) {
        fetchContents()
    }
    
    func fetchContents()->Void
    {
        myMapView.alpha=CGFloat(0.5)
        activityViewIndicator.hidden=false
        activityViewIndicator.startAnimating()
        PClient.sharedInstance().getLocationInfoFromParse() { (success, error) in
            performUIUpdatesOnMain{
                if success {
                    self.loadDataToMap()
                } else {
                    if let error = error {
                        self.activityViewIndicator.stopAnimating()
                        self.activityViewIndicator.hidden=true
                        self.myMapView.alpha=CGFloat(1.0)
                        let ac = UIAlertController(title: "", message: "Could not load  data", preferredStyle: .Alert)
                        ac.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
                        self.presentViewController(ac, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    
    
    
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        
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

