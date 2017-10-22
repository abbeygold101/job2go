//
//  HelperMethods.swift
//  Job 2 Go
//
//  Created by Abbey Ola on 20/10/2017.
//  Copyright © 2017 31st Bridge. All rights reserved.
//

import UIKit

class HelperMethods: NSObject {

    func showAlert(title: String, message: String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        return alert
    }
    
    func goToHomeScreen(viewController: UIViewController) {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = viewController.storyboard!.instantiateViewController(withIdentifier: "home")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
}
