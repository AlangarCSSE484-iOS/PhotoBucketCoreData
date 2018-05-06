//
//  AppDelegate.swift
//  PhotoBucket
//
//  Created by CSSE Department on 4/16/18.
//  Copyright © 2018 CSSE Department. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        //if Auth.auth().currentUser == nil
        let loggedIn = false;
        if loggedIn{
            showLoginViewController();
        } else {
            showPhotoBucketViewController();
        }
        return true
    }
    
    func showLoginViewController() {
        print ("Showing login view controller")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        window!.rootViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
    
    }
    
    func showPhotoBucketViewController() {
        print("showing photo bucket view controller")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let passwordViewController = storyboard.instantiateViewController(withIdentifier: "PasswordViewController")
        let photoBucketViewController = storyboard.instantiateViewController(withIdentifier: "PhotoBucketViewController")
       // window!.rootViewController = AppNavBar(rootViewController: passwordViewController)
    }


}
