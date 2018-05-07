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
        

        if Auth.auth().currentUser == nil {
            showLoginViewController();
        } else {
            showPhotoBucketViewController();
        }
        return true
    }
    
    func handleLogin() {
        showPhotoBucketViewController()
    }
    
    @objc func handleLogout() {
        do{
            try Auth.auth().signOut()
        } catch {
            print ("Error on signout: \(error.localizedDescription)")
        }
        showLoginViewController()
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

extension UIViewController {
    var appDelegate : AppDelegate{
        get{
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
}
