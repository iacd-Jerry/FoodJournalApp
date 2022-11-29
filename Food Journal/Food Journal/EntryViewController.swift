//
//  ViewController.swift
//  Food Journal
//
//  Created by IACD 015 on 2022/11/24.
//

import UIKit
import FirebaseAuth

class EntryViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        print("View appeared")
        let auth = FirebaseAuth.Auth.auth()
        
        if  auth.currentUser == nil{
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
            print("User is not signed in")
        }
        else
        {
                performSegue(withIdentifier: "dashboard", sender: nil)
        }
        
    }
}

