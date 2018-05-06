//
//  LoginViewController.swift
//  WeatherPics
//
//  Created by Kiana Caston on 5/6/18.
//  Copyright © 2018 Kiana Caston. All rights reserved.
//

import UIKit
import Material
import Firebase
import Rosefire
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    let ROSEFIRE_REGISTRY_TOKEN = "87a64c7c-2e4c-4aa6-ad17-b2b0f71c75e1"
    
    @IBOutlet weak var rosefireLoginButton: RaisedButton!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        //        googleLoginButton.style = .wide
        
    }
    
    func prepareView() {
        // Rosefire
        rosefireLoginButton.title = "Rosefire Login"
        rosefireLoginButton.titleColor = .white
        rosefireLoginButton.titleLabel!.font = RobotoFont.medium(with: 18)
        rosefireLoginButton.backgroundColor = UIColor(red: 0.5, green: 0, blue: 0, alpha: 0.9)
        rosefireLoginButton.pulseColor = .white
        
        // Google OAuth
        googleLoginButton.style = .wide
        
    }
    
    // MARK: - Login Methods
    func loginCompletionCallback(_ user: User?, _ error: Error?) {
        if let error = error {
            print("Error during log in: \(error.localizedDescription)")
            let ac = UIAlertController(title: "Login Failed",
                                       message: error.localizedDescription,
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Okay",
                                       style: .default,
                                       handler: nil))
            present(ac, animated: true)
        } else {
            appDelegate.handleLogin()
        }
    }
    
    @IBAction func rosefireLogin(_ sender: Any) {
        Rosefire.sharedDelegate().uiDelegate = self
        Rosefire.sharedDelegate().signIn(registryToken: ROSEFIRE_REGISTRY_TOKEN) {
            (error, result) in
            if let error = error {
                print("Error communicating with Rosefire! \(error.localizedDescription)")
                return
            }
            print("You are not signed in with Rosefire! username: \(result!.username)")
            Auth.auth().signIn(withCustomToken: result!.token,
                               completion: self.loginCompletionCallback)
            
        }
        
    }
    
    
}
