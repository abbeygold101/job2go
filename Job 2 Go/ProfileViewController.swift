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
    var saveAction = UIAlertAction()
    var cancelAction = UIAlertAction()
    let userInputView: UIView = {
        let tv = UIView()
        tv.backgroundColor = UIColor.darkGray
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.layer.masksToBounds = true
        return tv
    }()
    var whichProfileisEditing = EditProfile.skils
    var userInfo = [String:  Any]()
    let alertController = UIAlertController(title: "\n\n\n\n\n\n enter you story", message: nil, preferredStyle: .alert)
    let textView = UITextView(frame: CGRect.zero)
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
    var user: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAlertView()
        if Auth.auth().currentUser != nil {
            user = Auth.auth().currentUser
            if let user = user {
                let uid = user.uid
                
                Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {
                    (snapshot) in
                    print(snapshot)
                    if let snapshotDictionary = snapshot.value as? [String: Any]{
                        self.userInfo = snapshotDictionary
                        self.updatelabels(self.userInfo)
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
        whichProfileisEditing = .skils
        showAlert(title: AppConstant.skillsAlert)
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
        whichProfileisEditing = .language
        showAlert(title: AppConstant.languageAlert)
    }
    @IBAction func addAboutYou(_ sender: Any) {
        whichProfileisEditing = .about
        showAlert(title: AppConstant.aboutYouAlert)
    }
    @IBAction func addEducation(_ sender: Any) {
        whichProfileisEditing = .education
        showAlert(title: AppConstant.educationAlert)
    }
    @IBAction func addExperience(_ sender: Any) {
        whichProfileisEditing = .experience
        showAlert(title: AppConstant.experienceAlert)
    }
    
    func configureAlertView() {
        saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            action in
            self.saveInput(input: self.textView.text)
            self.removeInputObeserver()
        })
        
        saveAction.isEnabled = false
        
        cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
             self.removeInputObeserver()
        })
        
        textView.backgroundColor = .clear
        //textView.textColor = .gray
        textView.font = .systemFont(ofSize: 16)
        alertController.view.addSubview(textView)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
    }
    
    func showAlert(title: String) {
        saveAction.isEnabled = false
        let paragraph = "\n\n\n\n\n\n"
        alertController.title = paragraph + title
        alertController.view.addObserver(self, forKeyPath: "bounds", options: NSKeyValueObservingOptions.new, context: nil)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextViewTextDidChange, object: textView, queue: OperationQueue.main) { (notification) in
            self.saveAction.isEnabled = self.textView.text != ""
        }
        self.present(alertController, animated: true, completion: {
            self.textView.becomeFirstResponder()
        })
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
    
    func saveInput(input: String) {
        switch whichProfileisEditing {
        case .skils:
            userInfo[AppConstant.userSkills] = input
        case .about:
            userInfo[AppConstant.aboutUser] = input
        case .language:
            userInfo[AppConstant.language] = input
        case .education:
            userInfo[AppConstant.education] = input
        case .experience:
            userInfo[AppConstant.userExperience] = input
        }
        updatelabels(userInfo)
        let ref = Database.database().reference(fromURL: AppConstant.database)
        let usersRef = ref.child("users").child((user?.uid)!)
        usersRef.updateChildValues(userInfo)
    }
    
    func removeInputObeserver() {
        self.textView.text = ""
        self.alertController.view.removeObserver(self, forKeyPath: "bounds")
    }
    
    enum EditProfile {
        case skils, about, language, education, experience
    }
}
