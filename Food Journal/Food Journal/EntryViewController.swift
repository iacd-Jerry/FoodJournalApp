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
        //NB-- write code to check if the user is signed in or not using firebase
   
       
        //sleep(2)
        performSegue(withIdentifier: "login screen", sender: nil)
    }

}

