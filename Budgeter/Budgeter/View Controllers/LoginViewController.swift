//
//  LoginViewController.swift
//  Budgeter
//
//  Created by Ethan Andersen on 9/3/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    @IBAction func loginBtn(_ sender: Any) {
        let vc = vcGrabber(vcName: "budgetVC")
        self.navigationController?.pushViewController(vc, animated: true)
    } // End of Login button
} // End of Class
