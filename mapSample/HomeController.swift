//
//  HomeController.swift
//  mapSample
//
//  Created by Pedro on 11/2/18.
//  Copyright © 2018 Pedro. All rights reserved.
//

import UIKit

import GoogleMaps
import CoreFoundation

import Firebase
import FirebaseAuth
import FirebaseDatabase

import SVProgressHUD

import CoreLocation

import BraintreeDropIn
import Braintree



class HomeController: UIViewController, GMSMapViewDelegate, BTViewControllerPresentingDelegate, BTAppSwitchDelegate {

    //zoom button
    var currentMapZoomValue = Float()
    let MaxZoomAllowed : Float =  20.0
    let MinZoomAllowed : Float =  1.0
    
    //Change To GoogleMap
    
    @IBOutlet weak var viewMap: GMSMapView!
    
    var locationManager = CLLocationManager()
    
    var didFindMyLocation = false
    var locationMarker: GMSMarker!
    var originMarker: GMSMarker!
    var destinationMarker: GMSMarker!
    var routePolyline: GMSPolyline!
    var markersArray: Array<GMSMarker> = []
    var waypointsArray: Array<String> = []
    
    var LocationUpload_Flag: Bool = false
    
    
    
    
    let clientToken =    "eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiI3ZWFhNGM0ZDRkODhiYjEwMDExMDVhNGJjYzRjM2EyZmQ3NmZiNzIzZDdjNjVjMGY5NWYxZTA2NmQ4NzkxMDA1fGNyZWF0ZWRfYXQ9MjAxOC0wOC0yMFQwODoxNDowOS40NDAyNTcyMDcrMDAwMFx1MDAyNm1lcmNoYW50X2lkPTM0OHBrOWNnZjNiZ3l3MmJcdTAwMjZwdWJsaWNfa2V5PTJuMjQ3ZHY4OWJxOXZtcHIiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvMzQ4cGs5Y2dmM2JneXcyYi9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJjaGFsbGVuZ2VzIjpbXSwiZW52aXJvbm1lbnQiOiJzYW5kYm94IiwiY2xpZW50QXBpVXJsIjoiaHR0cHM6Ly9hcGkuc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbTo0NDMvbWVyY2hhbnRzLzM0OHBrOWNnZjNiZ3l3MmIvY2xpZW50X2FwaSIsImFzc2V0c1VybCI6Imh0dHBzOi8vYXNzZXRzLmJyYWludHJlZWdhdGV3YXkuY29tIiwiYXV0aFVybCI6Imh0dHBzOi8vYXV0aC52ZW5tby5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIiwiYW5hbHl0aWNzIjp7InVybCI6Imh0dHBzOi8vb3JpZ2luLWFuYWx5dGljcy1zYW5kLnNhbmRib3guYnJhaW50cmVlLWFwaS5jb20vMzQ4cGs5Y2dmM2JneXcyYiJ9LCJ0aHJlZURTZWN1cmVFbmFibGVkIjp0cnVlLCJwYXlwYWxFbmFibGVkIjp0cnVlLCJwYXlwYWwiOnsiZGlzcGxheU5hbWUiOiJBY21lIFdpZGdldHMsIEx0ZC4gKFNhbmRib3gpIiwiY2xpZW50SWQiOm51bGwsInByaXZhY3lVcmwiOiJodHRwOi8vZXhhbXBsZS5jb20vcHAiLCJ1c2VyQWdyZWVtZW50VXJsIjoiaHR0cDovL2V4YW1wbGUuY29tL3RvcyIsImJhc2VVcmwiOiJodHRwczovL2Fzc2V0cy5icmFpbnRyZWVnYXRld2F5LmNvbSIsImFzc2V0c1VybCI6Imh0dHBzOi8vY2hlY2tvdXQucGF5cGFsLmNvbSIsImRpcmVjdEJhc2VVcmwiOm51bGwsImFsbG93SHR0cCI6dHJ1ZSwiZW52aXJvbm1lbnROb05ldHdvcmsiOnRydWUsImVudmlyb25tZW50Ijoib2ZmbGluZSIsInVudmV0dGVkTWVyY2hhbnQiOmZhbHNlLCJicmFpbnRyZWVDbGllbnRJZCI6Im1hc3RlcmNsaWVudDMiLCJiaWxsaW5nQWdyZWVtZW50c0VuYWJsZWQiOnRydWUsIm1lcmNoYW50QWNjb3VudElkIjoiYWNtZXdpZGdldHNsdGRzYW5kYm94IiwiY3VycmVuY3lJc29Db2RlIjoiVVNEIn0sIm1lcmNoYW50SWQiOiIzNDhwazljZ2YzYmd5dzJiIiwidmVubW8iOiJvZmYifQ=="
    
    var braintreeClient: BTAPIClient!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        currentMapZoomValue = 6.0
        
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        
        locationManager.distanceFilter = 50
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        self.viewMap.isMyLocationEnabled = true
        
        self.viewMap.settings.myLocationButton = true
        self.viewMap.settings.compassButton = true
        self.viewMap.settings.zoomGestures = true
        
        self.viewMap.isIndoorEnabled = false
        
        viewMap.settings.allowScrollGesturesDuringRotateOrZoom = false
        
        
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 48.857165, longitude: 2.354613, zoom: 8.0)
        viewMap.camera = camera
        viewMap.delegate = self
        
        
        SVProgressHUD.show()
        Loading_Users(completionHandler: {success in
            
            SVProgressHUD.dismiss()
            if success == false { return }
            
            self.AddDataMarks()
        })
        
        self.braintreeClient = BTAPIClient(authorization: clientToken)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func AddDataMarks() {
        
        /*var locations = [
         Location_Info(title: "Burger & Lobster  1",     latitude: 51.510865, longitude: -0.150092),
         Location_Info(title: "Burger & Lobster  2",     latitude: 51.507865, longitude: -0.130092),
         Location_Info(title: "Burger & Lobster  3",     latitude: 51.542865, longitude: -0.127092),
         Location_Info(title: "Burger & Lobster  4",     latitude: 51.482865, longitude: -0.147092),
         Location_Info(title: "Burger & Lobster  5",     latitude: 51.492865, longitude: -0.137092),
         ]*/
        
        //or i in 0..<locations.count {
        for i in 0..<g_AllUsers_Array.count {
            var temp_location: Location_Info = Location_Info(title: "", latitude: 0.0, longitude: 0.0)
            temp_location.title = g_AllUsers_Array[i].title
            temp_location.latitude = g_AllUsers_Array[i].latitude
            temp_location.longitude = g_AllUsers_Array[i].longitude
            
            g_AllUsers_Array.append(temp_location)
        }
        
        
        
        for location in g_AllUsers_Array {
            let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let marker = GMSMarker()
            marker.position = coordinate
            marker.title = location.title
            marker.icon = UIImage(named: "mapIcon.png")
            marker.map = viewMap
        }
    }
    
    // Loading all users from firebase
    func Loading_Users(completionHandler: @escaping (Bool) -> Void) {
        
        g_AllUsers_Array.removeAll()
//
//
//        let user = FIRAuth.auth()?.currentUser
//        //let geofireRef = FIRDatabase.database().reference().child("Users").child((user?.uid)!)
 
        var handle: UInt = 0
        let Ref = FIRDatabase.database().reference().child("Users")
        handle = Ref.observe(.value, with: { (snapshot: FIRDataSnapshot!) in
            
            if snapshot.exists() {
                Ref.removeObserver(withHandle: handle)
            }
            
            if let dict = snapshot.value as? [String: AnyObject] {
                
                if (dict != nil ) {
                    for A_data in dict {
                        
                        print(A_data.key)   //Dkc1YteP1NdnsrA7zZ41WdMeKyf1
                        print(A_data.value) /*{
                                                Email = "test2@mail.com";
                                                Location =     {
                                                    latitude = "38.785834";
                                                    longitude = "-123.406417";
                                                };
                                                createdAt = 1541105042182;
                                            }*/
                        
                        
                        let B_dict = A_data.value as! [String: AnyObject]
                        var Temp: Location_Info = Location_Info(title: "", latitude: 0.0, longitude: 0.0)
                        
                        for B_data in B_dict {
                            
                            switch B_data.key {
                            case "Email":
                                Temp.title = B_data.value as! String
                            case "Location":
                                let C_dict = B_data.value as! [String: AnyObject]
                                for C_data in C_dict {
                                    if C_data.key == "latitude" {
                                        Temp.latitude = C_data.value as! Double
                                    } else {
                                        Temp.longitude = C_data.value as! Double
                                    }
                                }
                            default: break
                            }
                        }
                        
                        g_AllUsers_Array.append(Temp)
                    }
                    
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            }
       })
    }
    
    
    
    
}




extension HomeController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude), zoom: 8.0)
        self.viewMap?.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        //self.locationManager.stopUpdatingLocation()
        
        
        
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
                    self.locationManager.stopUpdatingLocation()
                }
            }
        }
        */
        
        g_latitude  = userLocation.coordinate.latitude
        g_longitude = userLocation.coordinate.longitude
        
        let user = FIRAuth.auth()?.currentUser
        let newMessage = FIRDatabase.database().reference().child("Users").child((user?.uid)!).child("Location")
        
        newMessage.removeValue()
        let messageData =
            ["latitude": g_latitude, "longitude": g_longitude] as [String : Any]
        newMessage.setValue(messageData)
        
        self.locationManager.stopUpdatingLocation()
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        showDropIn(clientTokenOrTokenizationKey: clientToken)
        //self.customPayPalButtonTapped()
    }
    
    
    
    
    
    
    
    
    
    
    
    //============================================================================================
    //                                                                                          //
    //                                                                                          //
    //      Payment Integration Braintree                                                       //
    //                                                                                          //
    //============================================================================================
    
    func postNonceToServer(paymentMethodNonce: String) {
        // Update URL with your server
        let paymentURL = URL(string: "https://your-server.example.com/payment-methods")!
        var request = URLRequest(url: paymentURL)
        request.httpBody = "payment_method_nonce=\(paymentMethodNonce)".data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            // TODO: Handle success or failure
            }.resume()
    }
    
    //BrainTree Payment
    func fetchClientToken() {
        // TODO: Switch this URL to your own authenticated API
        let clientTokenURL = NSURL(string: "https://braintree-sample-merchant.herokuapp.com/client_token")!
        let clientTokenRequest = NSMutableURLRequest(url: clientTokenURL as URL)
        clientTokenRequest.setValue("text/plain", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: clientTokenRequest as URLRequest) { (data, response, error) -> Void in
            // TODO: Handle errors
            let clientToken = String(data: data!, encoding: String.Encoding.utf8)
            
            // As an example, you may wish to present Drop-in at this point.
            // Continue to the next section to learn more...
            }.resume()
    }
    
    func showDropIn(clientTokenOrTokenizationKey: String) {
        let request =  BTDropInRequest()
        
        var totalPrice: Float = 50.0
        
        if totalPrice == 0.0 {
            return
        }
        
        request.amount = "\(String(totalPrice))"
        
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            if (error != nil) {
                print("ERROR")
//                DispatchQueue.main.async {
//                    self.view.makeToast("Your payment action is failed.", duration: 2.3, position: .bottom)
//                }
                
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
            } else if let result = result {
                // Use the BTDropInResult properties to update your UI
                // result.paymentOptionType
                // result.paymentMethod
                // result.paymentIcon
                // result.paymentDescription
                
                switch result.paymentOptionType {
                case BTUIKPaymentOptionType.payPal :
                    print("payPal integration")
                    //self.customPayPalButtonTapped()
                    
                    
                case BTUIKPaymentOptionType.visa :
                    print("visa integration")
                    //self.customPayPalButtonTapped() // will change visa method
                    
                default: break
                }
                
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }
    
    func customPayPalButtonTapped() {
        let payPalDriver = BTPayPalDriver(apiClient: self.braintreeClient)
        payPalDriver.viewControllerPresentingDelegate = self
        payPalDriver.appSwitchDelegate = self
        
        // Start the Vault flow, or...
        /*payPalDriver.authorizeAccount() { (tokenizedPayPalAccount, error) -> Void in
         //...
         }*/
        
        // Collect Billing address
        /*payPalDriver.authorizeAccount(withAdditionalScopes: Set(["address"])) { (tokenizedPayPalAccount, error) in
         guard let tokenizedPayPalAccount = tokenizedPayPalAccount else {
         if let error = error {
         // Handle error
         } else {
         // User canceled
         }
         return
         }
         if let address = tokenizedPayPalAccount.billingAddress ?? tokenizedPayPalAccount.shippingAddress {
         print("Billing address:\n\(address.streetAddress)\n\(address.extendedAddress)\n\(address.locality) \(address.region)\n\(address.postalCode) \(address.countryCodeAlpha2)")
         }
         }
         */
        
        // ...start the Checkout flow
        //let payPalRequest = BTPayPalRequest(amount: "1.00")
        var totalPrice: Float = 50.0

        if totalPrice == 0.0 {
            return
        }
        let payPalRequest = BTPayPalRequest(amount: "\(String(totalPrice))")
        
        payPalDriver.authorizeAccount(withAdditionalScopes: Set(["address"])) { (tokenizedPayPalAccount, error) in
            guard let tokenizedPayPalAccount = tokenizedPayPalAccount else {
                if let error = error {
                    // Handle error
                } else {
                    // User canceled
                }
//                DispatchQueue.main.async {
//                    self.view.makeToast("Your payment action is failed.", duration: 2.3, position: .bottom)
//                }
                return
            }
            
            if let address = tokenizedPayPalAccount.billingAddress ?? tokenizedPayPalAccount.shippingAddress {
                print("Billing address:\n\(address.streetAddress)\n\(address.extendedAddress)\n\(address.locality) \(address.region)\n\(address.postalCode) \(address.countryCodeAlpha2)")
            }
            
        }
    }
    
    
    // MARK: - BTViewControllerPresentingDelegate =============================================
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - BTAppSwitchDelegate ===========================================================
    // Optional - display and hide loading indicator UI
    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
        showLoadingUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideLoadingUI), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
        hideLoadingUI()
    }
    
    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
        
    }
    
    // MARK: - Private methods ==============================================================
    func showLoadingUI() {
        // ...
    }
    
    @objc func hideLoadingUI() {
        NotificationCenter
            .default
            .removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        // ...
    }

    
    
    
    
}
