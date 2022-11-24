//
//  ViewController.swift
//  Food Journal
//
//  Created by IACD 015 on 2022/11/24.
//

import UIKit

class EntryViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let loggedIn = UserDefaults.standard.bool(forKey: "logged_in")
        
        if !loggedIn{
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
            print("Here presenting")
        }
        
    }
}

