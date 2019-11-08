//
//  AppDelegate.swift
//  mapSample
//
//  Created by Pedro on 11/2/18.
//  Copyright © 2018 Pedro. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Braintree
import BraintreeDropIn

import FBSDKCoreKit
import FBSDKLoginKit

import Firebase
import GoogleSignIn

import GoogleMaps
import GooglePlaces


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
                
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        BTAppSwitch.setReturnURLScheme("mapSamples.mapSamples.com.payments")
        
        //Firebase configure setting
        FIRApp.configure()
        
        //Google Sign
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        
        //'GMSServicesException', reason: 'Google Maps SDK for iOS must be initialized via [GMSServices provideAPIKey:...] prior to use'
        GMSServices.provideAPIKey("AIzaSyDbWMdhrW-xr3XjLMAa-XK4Y4yuH7iHEbc")
        
        //Google Address
        //GMSPlacesClient.provideAPIKey("AIzaSyDyHgXAMkyKT7dOZf9EqflouSeP-gZOfIg")

        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handled  = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        if url.scheme?.localizedCaseInsensitiveCompare("mapSamples.mapSamples.com.payments") == .orderedSame {
            return BTAppSwitch.handleOpen(url, options: options)
        }
        
        return handled
    }
    
    // If you support iOS 7 or 8, add the following method.
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if url.scheme?.localizedCaseInsensitiveCompare("mapSamples.mapSamples.com.payments") == .orderedSame {
            return BTAppSwitch.handleOpen(url, sourceApplication: sourceApplication)
        }
        return false
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

