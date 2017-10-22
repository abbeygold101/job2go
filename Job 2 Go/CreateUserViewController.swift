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
    let helperMethods = HelperMethods()
    @IBOutlet weak var doneresettingPasswordView: UIView!
    @IBOutlet weak var resetPasswordView: UIView!
    @IBOutlet weak var resetEmailtextField: UITextField!
    @IBOutlet weak var loginPasswordtextField: UITextField!
    @IBOutlet weak var loginEmailTextFiled: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextfield: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordtextField: UITextField!
    @IBOutlet weak var signupSigninToggle: UISegmentedControl!
    @IBOutlet weak var signupViewLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var singUpViewConstrintCenterX: NSLayoutConstraint!
    @IBOutlet weak var signUpViewContainer: UIView!
    @IBOutlet weak var signUpScrollview: UIScrollView!
    @IBOutlet weak var scrollViewcenterXconstraint: NSLayoutConstraint!
    @IBOutlet weak var signInViewContainer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        signupSigninToggle.addTarget(self, action: #selector(signupSigninToggleScreen), for: .valueChanged)
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
            self.helperMethods.goToHomeScreen(viewController: self)
        })
    }
    
    func handleLoginRegisterScreen() {
        
    }
    
    func presentLoginView()  {
        signUpViewContainer.isHidden = true
        signInViewContainer.isHidden = false
        view.endEditing(true)
    }
    
    func presentRegisterView()  {
        signUpViewContainer.isHidden = false
        signInViewContainer.isHidden = true
    }
   
    @objc func signupSigninToggleScreen(segment: UISegmentedControl) {
        doneresettingPasswordView.isHidden = true
        resetPasswordView.isHidden = true
        if segment.selectedSegmentIndex == 0 {
            presentRegisterView()
        }
        else{
            presentLoginView()
        }
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        view.endEditing(true)
        guard let email = loginEmailTextFiled.text, let password = loginPasswordtextField.text  else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
            if error != nil{
                 print("\(String(describing: error))")
                return
            }
            self.helperMethods.goToHomeScreen(viewController: self)
        })
    }
    
    @IBAction func resetPassword(_ sender: Any) {
        guard let email = resetEmailtextField.text else{
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email){ error in
           if error != nil{
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    let title = "Error"
                    switch errCode {
                    case .invalidEmail:
                        let alertView = self.helperMethods.showAlert(title: title, message: AppConstant.invalidEmail)
                        self.present(alertView, animated: true, completion: nil)
                    case .userNotFound:
                        let alertView = self.helperMethods.showAlert(title: title, message: AppConstant.userNotFound)
                        self.present(alertView, animated: true, completion: nil)
                    case .missingEmail:
                        let alertView = self.helperMethods.showAlert(title: title, message: AppConstant.missingEmail)
                        self.present(alertView, animated: true, completion: nil)
                    default:
                        print("Other error!")
                    }

                }
                return
            }
            self.signUpViewContainer.isHidden = true
            self.signInViewContainer.isHidden = true
            self.doneresettingPasswordView.isHidden = false
            self.resetPasswordView.isHidden = true
        }
    }

    @IBAction func signinAfterPasswordRest(_ sender: Any) {
        signUpViewContainer.isHidden = true
        signInViewContainer.isHidden = false
        doneresettingPasswordView.isHidden = true
        resetPasswordView.isHidden = true
    }
    @IBAction func forgotPassword(_ sender: Any) {
        signUpViewContainer.isHidden = true
        signInViewContainer.isHidden = true
        doneresettingPasswordView.isHidden = true
        resetPasswordView.isHidden = false
    }
}
