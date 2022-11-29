//
//  NavigationViewController.swift
//  Food Journal
//
//  Created by IACD 015 on 2022/11/24.
//

import UIKit
import FirebaseAuth

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
 
        let auth = FirebaseAuth.Auth.auth()
        
        if  auth.currentUser != nil{
            self.pushViewController(DashBoardViewController(), animated: false)
            print("User signed in")
        }
        
    }

}
