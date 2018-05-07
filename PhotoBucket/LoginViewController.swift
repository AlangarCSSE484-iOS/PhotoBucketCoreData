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
    
    let rosefireRegistryToken = "a3060971-cddb-4332-b25f-1f0601ca058e"
    
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
        prepareView()

        // Do any additional setup after loading the view.
    }
    
    func prepareView() {
        self.view.backgroundColor = Color.indigo.base
        titleLabel.font = RobotoFont.thin(with: 36)
        
        // Email / Password
        //prepareEmailPasswordCard()
        
        // Rosefire
        rosefireLoginButton.title = "Rosefire Login"
        rosefireLoginButton.titleColor = .white
        rosefireLoginButton.titleLabel!.font = RobotoFont.medium(with: 18)
        rosefireLoginButton.backgroundColor = UIColor(red: 0.5, green: 0, blue: 0, alpha: 0.9)
        rosefireLoginButton.pulseColor = .white
        
        // Google OAuth
        //    googleLoginButton.style = .wide
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    
    // MARK: - Navigation
 
    func loginCompletionCallback(_ user: User?, _ error: Error?){
        if let error = error {
            print("Error during log in: \(error.localizedDescription)")
            let ac = UIAlertController(title: "Login failed",
                                       message: error.localizedDescription,
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok",
                                       style: .default,
                                       handler: nil))
            present(ac, animated: true)
        } else {
            appDelegate.handleLogin()
        }
    }

    
    @IBAction func rosefireLogin(_ sender: Any) {
        Rosefire.sharedDelegate().uiDelegate = self
        Rosefire.sharedDelegate().signIn(registryToken: rosefireRegistryToken) { (error, result) in
            if let error = error {
                print ("Error communicating with Rosefire! \(error.localizedDescription)" )
                return
            }
            print("You are now signed in with Rosefire! username: \(result!.username!)")

            Auth.auth().signIn(withCustomToken: result!.token,
                               completion: self.loginCompletionCallback)

        }
        print("Pressed Rosefire Login")
        
    }
}
