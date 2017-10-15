//
//  JobDetailViewController.swift
//  Job 2 Go
//
//  Created by Abbey Ola on 15/10/2017.
//  Copyright © 2017 31st Bridge. All rights reserved.
//

import UIKit

class JobDetailViewController: UIViewController {
    var job : JobModel?

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
        
        employer.text = job?.employer
        jobTitle.text =  job?.title.uppercased()
        jobDesscription.text = job?.jobDescription
        location.text = job?.location
        offer.text = "Offer: ₦\(job!.offer)"
    }

}
