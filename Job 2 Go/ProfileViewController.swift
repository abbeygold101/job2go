//
//  ProfileViewController.swift
//  Job 2 Go
//
//  Created by Abbey Ola on 14/10/2017.
//  Copyright © 2017 31st Bridge. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import FirebaseDatabase

class ProfileViewController: UIViewController {
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    let userInputView: UIView = {
        let tv = UIView()
        tv.backgroundColor = UIColor.darkGray
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.layer.masksToBounds = true
        //x, y, width, height constraints
        return tv
    }()
    
    let textView = UITextView()
    @IBOutlet weak var addskillsButton: UIButton!
    @IBOutlet weak var skillLabeltrailingConstrainst: NSLayoutConstraint!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var skillLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var educationLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    var url : URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            if let user = user {
                let uid = user.uid
                
                Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {
                    (snapshot) in
                    print(snapshot)
                    if let userinfo = snapshot.value as? [String: Any]{
                        self.updatelabels(userinfo)
                    }
                }, withCancel: nil)
 
//                let email = user.email
                url = user.photoURL
               // let name = user.displayName
                
                //self.updatelabels(name ?? "name not found")
            } else {
                print("no user ")
            }
        }
    }
    func updatelabels(_ userinfo: [String: Any]){
        nameLabel.text = userinfo["name"] as? String
        //userLocationLabel.text = userinfo[AppConstant.userLocation] as? String
        if let userSkills  = userinfo[AppConstant.userSkills] as? String, userSkills != ""{
            skillLabel.text = userSkills
            skillLabel.textColor = .black
            addskillsButton.isHidden = true
            skillLabeltrailingConstrainst.constant = 16
        }
        if let aboutYou  = userinfo[AppConstant.aboutUser] as? String, aboutYou != ""{
            aboutLabel.text = aboutYou
            aboutLabel.textColor = .black
            addAboutyouButton.isHidden = true
            aboutTrailingConstariant.constant = 16
        }
        if let language  = userinfo[AppConstant.language] as? String, language != ""{
            languageLabel.text = language
            languageLabel.textColor = .black
            addLanguagesButton.isHidden = true
            languageTrailingConstariant.constant = 16
        }
        if let education  = userinfo[AppConstant.education] as? String, education != ""{
            educationLabel.text = education
            educationLabel.textColor = .black
            addEducationButton.isHidden = true
            educationTrailingConstraint.constant = 16
        }
        if let experience  = userinfo[AppConstant.userExperience] as? String, experience != ""{
            experienceLabel.text = experience
            experienceLabel.textColor = .black
            addExperienceButton.isHidden = true
            experincetrailingConstraint.constant = 16
        }
//        aboutLabel.text = userinfo[AppConstant.aboutUser] as? String
//        languageLabel.text = userinfo[AppConstant.language] as? String
//        educationLabel.text = userinfo[AppConstant.education] as? String
//        experienceLabel.text = userinfo[AppConstant.userExperience] as? String
        
        if let photourl = userinfo[AppConstant.userphotourl] as? String, let imageurl = URL(string : photourl){
            userProfileImageView.kf.setImage(with: imageurl)
        }
    }
    @IBAction func logoutButtonTapped(_ sender: Any) {
        try! Auth.auth().signOut()
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "introScreen")
            appDelegate.window?.rootViewController = initialViewController
            appDelegate.window?.makeKeyAndVisible()
    }
    
    @IBAction func addSkills(_ sender: Any) {
    }
    @IBOutlet weak var aboutTrailingConstariant: NSLayoutConstraint!
    @IBOutlet weak var languageTrailingConstariant: NSLayoutConstraint!
    @IBOutlet weak var educationTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var experincetrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var addEducationButton: UIButton!
    @IBOutlet weak var addAboutyouButton: UIButton!
    @IBOutlet weak var addLanguagesButton: UIButton!
    @IBOutlet weak var addExperienceButton: UIButton!
    @IBAction func addLanguages(_ sender: Any) {
        contentView.addSubview(userInputView)
        userInputView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userInputView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        userInputView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        userInputView.heightAnchor.constraint(equalToConstant: 100)
 //       showAlert()
//        let alertController = UIAlertController(title: "Email?", message: "Please input your email:", preferredStyle: .alert)
//
//        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
//            if let field = alertController.textFields![0] as? UITextField{
//                print(field.text)
//            } else {
//                // user did not fill field
//            }
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
//
//        alertController.addTextField(configurationHandler: {(textField) in
//            textField.placeholder = "Email"
//        })
//
        
//        alertController.addTextFieldWithConfigurationHandler { (textField) in
//            textField.placeholder = "Email"
//        }
        
//        alertController.addAction(confirmAction)
//        alertController.addAction(cancelAction)
//        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func addAboutYou(_ sender: Any) {
    }
    @IBAction func addEducation(_ sender: Any) {
    }
    @IBAction func addExperience(_ sender: Any) {
    }
    
    func showAlert() {
        let alertController = UIAlertController()
        
        let saveAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        saveAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.view.addObserver(self, forKeyPath: "bounds", options: NSKeyValueObservingOptions.new, context: nil)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextViewTextDidChange, object: textView, queue: OperationQueue.main) { (notification) in
            saveAction.isEnabled = self.textView.text != ""
        }
        
        textView.backgroundColor = UIColor.green
        alertController.view.addSubview(textView)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "bounds"{
            if let rect = (change?[NSKeyValueChangeKey.newKey] as? NSValue)?.cgRectValue{
                let margin:CGFloat = 8.0
                textView.frame = CGRect(x: rect.origin.x + margin, y: rect.origin.y + margin, width: rect.width - 2 * margin, height: rect.height / 2)
                textView.bounds = CGRect(x: rect.origin.x + margin,y: rect.origin.y + margin, width: rect.width - 2 * margin, height: rect.height / 2)
            }
        }
    }
    
//    override func observeValue(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutableRawPointer) {
//        if keyPath == "bounds"{
//            if let rect = (change?[NSKeyValueChangeNewKey] as? NSValue)?.CGRectValue(){
//                let margin:CGFloat = 8.0
//                textView.frame = CGRectMake(rect.origin.x + margin, rect.origin.y + margin, CGRectGetWidth(rect) - 2*margin, CGRectGetHeight(rect) / 2)
//                textView.bounds = CGRectMake(rect.origin.x + margin, rect.origin.y + margin, CGRectGetWidth(rect) - 2*margin, CGRectGetHeight(rect) / 2)
//            }
//        }
//    }
}
