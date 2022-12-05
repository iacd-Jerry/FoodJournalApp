//
//  LoginViewController.swift
//  Food Journal
//
//  Created by IACD 015 on 2022/11/24.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet var password: UITextField!
    @IBOutlet var emailAdd: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad() 

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        
    }
    
    @IBAction func loginButtonTapped(_ senderB: Any) {
        print("Login button pressed")
        if password.text == nil || emailAdd.text == nil{
            print("Login fields are empty")
            return
        }
        
        let auth = FirebaseAuth.Auth.auth()
        let email = emailAdd.text!
        print("Trying to log in with email \(email) which has \(email.count) characteres")
        auth.signIn(withEmail: email, password: password.text!) { _ , err in
            if  err != nil{
                print("Error message \(err?.localizedDescription)")
                return
            }
            self.performSegue(withIdentifier: "dashboard", sender: nil)
            //maybe present next controller from here
        }
    }
    
    
    func alertUserOfError(){
        print("Failed to log in")
    }
    
}  //End of body
