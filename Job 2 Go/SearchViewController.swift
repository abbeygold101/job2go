//
//  SearchViewController.swift
//  Job 2 Go
//
//  Created by Abbey Ola on 14/10/2017.
//  Copyright © 2017 31st Bridge. All rights reserved.
//

import UIKit

public typealias JobModel = (postId: String , title: String, location: String, employer: String,
    jobDescription: String, dateAndTime: String, offer:  String, imageUrl: String)

class SearchViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate {
    let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addSearchBar()

    }

    func addSearchBar() {
        searchBar.placeholder = "Search for Job by location or Job title"
        searchBar.delegate = self
        searchBar.tintColor = .red
        
        self.navigationItem.titleView = searchBar
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
