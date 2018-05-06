//
//  LoginViewController.swift
//  PhotoBucket
//
//  Created by CSSE Department on 5/5/18.
//  Copyright © 2018 CSSE Department. All rights reserved.
//

import UIKit
import Material
import Firebase
import Rosefire
import GoogleSignIn



class LoginViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailPasswordCard: Card!
    @IBOutlet weak var emailPasswordCardContent: UIView!
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    
    @IBOutlet weak var rosefireLoginButton: RaisedButton!
    // @IBOutlet weak var googleLoginButton: UIView!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func rosefireLogin(_ sender: Any) {
//        Rosefire.sharedDelegate().uiDelegate = self
//        Rosefire.sharedDelegate().signIn(registryToken: rosefireRegistryToken) { (error, result) in
//            if let error = error {
//                print ("Error communicating with Rosefire! \(error.localizedDescription)" )
//                return
//            }
//            print("You are now signed in with Rosefire! username: \(result!.username!)")
//
//            Auth.auth().signIn(withCustomToken: result!.token,
//                               completion: self.loginCompletionCallback)
//
//        }
        print("Pressed Rosefire Login")
        
    }
}
