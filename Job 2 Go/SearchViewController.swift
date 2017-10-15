//
//  SearchViewController.swift
//  Job 2 Go
//
//  Created by Abbey Ola on 14/10/2017.
//  Copyright © 2017 31st Bridge. All rights reserved.
//

import UIKit

public typealias JobModel = (postId: String , title: String, location: String, employer: String,
    jobDescription: String, jobTime: String, offer:  String, imageUrl: String)

class SearchViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UITableViewDataSource {
    let searchBar = UISearchBar()
     let webHost = "http://31stbridge.com/newjobapp/jobBoard.php"
     let ImageHost = "http://31stbridge.com/newjobapp/uploads"
    var jobList = [JobModel]()
    @IBOutlet weak var jobTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSearchBar()
        getJsonFromUrl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }

    func addSearchBar() {
        searchBar.placeholder = "Search for Job by location or Job title"
        searchBar.delegate = self
        searchBar.tintColor = .red
        
        self.navigationItem.titleView = searchBar
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return jobList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "jobCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? JobCell else{
            fatalError("AppConstants.fatalError")
        }
        
        let job = jobList[indexPath.row]
        
        let title = job.title
        //let replacementtext = title.replacingOccurrences(of: " N ", with: AppConstants.sparklingHeart )
        cell.title.text = title.uppercased()
        cell.employer.text =  "Poste by: " + job.employer
        cell.jobDescribtion.text = job.jobDescription
        cell.location.text = job.location
        cell.offer.text = "Offer: ₦\(job.offer)"
        //let url = URL(string: job.imageUrl)
       // cell.pictureFrame.kf.setImage(with: url)
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "jobDetail":
            guard let JobDetail = segue.destination as? JobDetailViewController else {
                fatalError("fatal Error : \(segue.destination)")
            }
            
            guard let selectedJobCell = sender as? JobCell else {
                fatalError("fatal Error : \(String(describing: sender))")
            }
            
            guard let indexPath = jobTable.indexPath(for: selectedJobCell) else {
                fatalError("AppConstants.cellIndexError")
            }
            
            let selectedJob = jobList[indexPath.row]
            JobDetail.job = selectedJob
            
        //case AppConstants.aboutUs: break
        //case AppConstants.searchScreen: break
        default:
            fatalError("AppConstants.unexpectedDestination : \(String(describing: segue.identifier))")
        }
    }
    
    func getJsonFromUrl(){
        let url = URL(string: webHost)
        
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                if let jobArray = jsonObj!.value(forKey: "jobs") as? NSArray {
                    for job in jobArray{
                        if let jobDict = job as? NSDictionary {
                            if let title = jobDict.value(forKey: "title") as? String , let employer = jobDict.value(forKey: "employer") as? String , let location = jobDict.value(forKey: "location") as? String , let image = jobDict.value(forKey: "Image_url") as? String {
                                let jobDescription = jobDict.value(forKey: "jobDescription") as? String ?? ""
                                let jobTime = jobDict.value(forKey: "jobTime") as? String ?? ""
                                let offer = jobDict.value(forKey: "offer") as? String ?? ""
                                let post_id = jobDict.value(forKey: "post_id") as? String ?? ""
                                let imageUrl = self.webHost.appending(image)
                                
                                let listedJob = JobModel(post_id, title, location, employer, jobDescription, jobTime, offer, imageUrl)
                                self.jobList.append(listedJob)
                            }
                            
                        }
                    }
                }
                
                OperationQueue.main.addOperation({
                    self.jobTable.reloadData()
                })
            }
        }).resume()
    }
}
