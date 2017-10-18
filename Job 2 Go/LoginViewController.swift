//
//  LoginViewController.swift
//  Job 2 Go
//
//  Created by Abbey Ola on 16/10/2017.
//  Copyright © 2017 31st Bridge. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let accessToken = AccessToken.current {
            print("\(accessToken.userId)")
        }
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func facebookButtonTapped(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn([.publicProfile, .email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                Auth.auth().signIn(with: credential) { (user, error) in
                    if let error = error {
                        // ...
                        return
                    }
                    print(user?.displayName)
                    //user?.phoneNumber
                }
            }
            
        }
    }
    
    @IBAction func createAnAccountButtonTapped(_ sender: Any) {
//        let createAccountView = CreateUserViewController()
//        present(createAccountView, animated: true, completion: nil)
    }
    
}
