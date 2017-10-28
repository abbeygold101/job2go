//
//  ChatsViewController.swift
//  Job 2 Go
//
//  Created by Abbey Ola on 27/10/2017.
//  Copyright © 2017 31st Bridge. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ChatWindowViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate{
    var whoAreYouChattingWith: String?{
        didSet{
            navigationItem.title = whoAreYouChattingWith
        }
    }
    let ref = Database.database().reference(fromURL: "https://job2go-996f6.firebaseio.com/")
    lazy var messageinputField : UITextField = {
        let inputTextField = UITextField()
        inputTextField.placeholder = " Enter message ..."
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.delegate = self
        return inputTextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.title = whoAreYouChattingWith ?? "Chat Window"
        setUpView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setUpView() {
        collectionView?.backgroundColor = .white
        let container = UIView()
    
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        container.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: container.heightAnchor).isActive = true
        
        container.addSubview(messageinputField)
        messageinputField.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        messageinputField.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        messageinputField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        messageinputField.heightAnchor.constraint(equalTo: container.heightAnchor).isActive = true
        
        let seperator = UIView()
        container.addSubview(seperator)
        seperator.backgroundColor = .lightGray
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        seperator.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        seperator.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func sendMessage() {
        
        guard let message = messageinputField.text, message != "" else { return }
        messageinputField.text = ""
        let childRef = ref.child("chats").childByAutoId()
        let fromWho = Auth.auth().currentUser?.uid
        let timeStamp = String (NSDate().timeIntervalSince1970)
        let value = ["text" : message, "userID": whoAreYouChattingWith, "fromWho" : fromWho, "timeStamp" : timeStamp]
        childRef.updateChildValues(value)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
}
