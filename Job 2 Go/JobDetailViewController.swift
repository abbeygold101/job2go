//
//  JobDetailViewController.swift
//  Job 2 Go
//
//  Created by Abbey Ola on 15/10/2017.
//  Copyright © 2017 31st Bridge. All rights reserved.
//

import UIKit
import Firebase
import QuartzCore

class JobDetailViewController: UIViewController {
    var job : JobModel?
    var handle: AuthStateDidChangeListenerHandle?

    @IBOutlet weak var employerImage: UIImageView!
    @IBOutlet weak var employer: UILabel!
    @IBOutlet weak var offer: UILabel!
    @IBOutlet weak var jobDesscription: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var jobBanner: UIImageView!
    @IBAction func backButtonTapped(_ sender: Any) {
        print("tapped")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        navigationItem.title = job?.title
        employer.text = job?.employer
        jobTitle.text =  job?.title.uppercased()
        jobDesscription.text = job?.jobDescription
        location.text = job?.location
        offer.text = "Offer: ₦\(job!.offer)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
        
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    @IBAction func openChatController(_ sender: Any) {
        let layout = UICollectionViewFlowLayout()
        let chatWindowViewController = ChatWindowViewController(collectionViewLayout: layout)
        chatWindowViewController.whoAreYouChattingWith = employer.text
        navigationController?.pushViewController(chatWindowViewController, animated: true)
    }
    
}
