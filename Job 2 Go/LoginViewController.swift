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
import FirebaseDatabase

class LoginViewController: UIViewController {

    let helperMethods = HelperMethods()
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
                    self.registerUser(user!)
                    self.helperMethods.goToHomeScreen(viewController: self)
                }
            }
            
        }
    }
    
    @IBAction func createAnAccountButtonTapped(_ sender: Any) {
//        let createAccountView = CreateUserViewController()
//        present(createAccountView, animated: true, completion: nil)
    }
    
    func registerUser(_ user : User) {
        guard let name = user.displayName else{return}
        let email = user.email ?? ""
        let phoneNumber = user.phoneNumber ?? ""
        let photoUrl = user.photoURL?.description ?? ""
        let ref = Database.database().reference(fromURL: "https://job2go-996f6.firebaseio.com/")
        let usersRef = ref.child("users").child(user.uid)
        let values = ["name": name, "email": email, "phone": phoneNumber, "photo" : photoUrl]
        usersRef.updateChildValues(values)
    }
    
}
