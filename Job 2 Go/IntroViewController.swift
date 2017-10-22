//
//  IntroViewController.swift
//  Job 2 Go
//
//  Created by Abbey Ola on 16/10/2017.
//  Copyright © 2017 31st Bridge. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FacebookCore
import FacebookLogin
import Firebase

class IntroViewController: UIViewController, FBSDKLoginButtonDelegate {
    let helperMethods = HelperMethods()
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
       // self.firebaseLogin(credential)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                // ...
                return
            }
            // User is signed in
            // ...
        }
    }
    
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        //
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
            self.helperMethods.goToHomeScreen(viewController: self)
            //let homeViewColler = <#value#>
            
//            let user = Auth.auth().currentUser
//            if let user = user {
//                let uid = user.uid
//                let email = user.email
//                let photoURL = user.photoURL
//                let name = user.displayName
//                print(name)
            }
//        } else {
//            print("no user ")
//        }
    }
}
