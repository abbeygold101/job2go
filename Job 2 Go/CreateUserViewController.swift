//
//  CreateUserViewController.swift
//  Job 2 Go
//
//  Created by Abbey Ola on 17/10/2017.
//  Copyright © 2017 31st Bridge. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CreateUserViewController: UIViewController {
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextfield: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordtextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    @IBAction func cancelRegistration(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordtextField.text, let firstname = firstnameTextField.text, let lastname = lastnameTextfield.text, let phoneNumber = phoneNumberTextField.text else {
            return
        }
        let name = firstname + " " + lastname
        
        Auth.auth().createUser(withEmail: email, password: password, completion: {(user: User?, error) in
            
            if error != nil{
                print("\(String(describing: error))")
                return
            }
            guard let uid = user?.uid else{
                return
            }
            
            let ref = Database.database().reference(fromURL: "https://job2go-996f6.firebaseio.com/")
            let usersRef = ref.child("users").child(uid)
            let values = ["name": name, "email": email, "phone": phoneNumber]
            usersRef.updateChildValues(values)
            self.goToHomeScreen()
        })
    }
    
    func goToHomeScreen() {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "myTabbarControllerID")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
}
