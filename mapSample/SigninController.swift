//
//  ViewController.swift
//  mapSample
//
//  Created by Pedro on 11/2/18.
//  Copyright © 2018 Pedro. All rights reserved.
//

import UIKit
import Firebase

import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

import CoreLocation

class SigninController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_pass: UITextField!
    @IBOutlet weak var btn_signin: UIButton!
    
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        txt_email.layer.cornerRadius = 5.0
        txt_email.layer.borderColor = UIColor.lightGray.cgColor
        txt_email.layer.borderWidth = 1
        
        txt_pass.layer.cornerRadius = 5.0
        txt_pass.layer.borderColor = UIColor.lightGray.cgColor
        txt_pass.layer.borderWidth = 1
        
        btn_signin.layer.cornerRadius = 5.0
        btn_signin.layer.borderColor = UIColor.lightGray.cgColor
        btn_signin.layer.borderWidth = 1
        
        
        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        //Get Location=====================================
        determineMyCurrentLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //====================================================
    //
    //   Get Location
    //
    //====================================================
    var location_l_0: String = ""
    var location_l_1: String = ""
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    var LocationUpload_Flag: Bool = false
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation
        
        /*let user = FIRAuth.auth()?.currentUser
        let geofireRef = FIRDatabase.database().reference().child("Users").child((user?.uid)!)
        let geoFire = GeoFire(firebaseRef: geofireRef)
        if self.LocationUpload_Flag == false {
            //One time Upload Location
            geoFire!.setLocation(userLocation, forKey: "Location") { (error) in
                if (error != nil) {
                    debugPrint("An error occured: \(error)")
                } else {
                    self.LocationUpload_Flag = true
                }
            }
        }*/
        
        
        g_latitude  = userLocation.coordinate.latitude
        g_longitude = userLocation.coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
        //self.location_switch.setOn(false, animated: false)
    }
    
    
    
    
    
    @IBAction func onTappedSignin(_ sender: Any) {
        
        if ((txt_email.text?.characters.count)! < 1 || (txt_pass.text?.characters.count)! < 1) {
            //self.view.dodo.error(UserDialogs.CompleteRequireFields.rawValue)
            return
        }

        if self.txt_email.text == "" || self.txt_pass.text == ""
        {
            let alertController = UIAlertController(title: "Alert!", message: "Please enter an email and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            SVProgressHUD.show()
            FIRAuth.auth()?.signIn(withEmail: self.txt_email.text!, password: self.txt_pass.text!) { (user, error) in
                
                SVProgressHUD.dismiss()
                
                if error == nil
                {
                    print("suceess")
                    self.performSegue(withIdentifier: "SignInToHomeVC", sender: self)
                    
                } else {
                    
                    self.txt_email.text = ""
                    self.txt_pass.text = ""
                    
                    let alertController = UIAlertController(title: "Alert!", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    
}

