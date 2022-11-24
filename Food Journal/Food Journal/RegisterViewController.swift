//
//  RegisterViewController.swift
//  Food Journal
//
//  Created by IACD 015 on 2022/11/24.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet var firstName: UITextField!
    @IBOutlet var emailAdd: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var lastName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func registerButtonTapped(_ sender: UIButton) {
        guard let fName = firstName.text, !fName.isEmpty , let lName = lastName.text, !lName.isEmpty , let email = emailAdd.text, !email.isEmpty , let pass = password.text, !pass.isEmpty
                else{
            self.alertUserOfError()
            return
        }
        
        let auth = FirebaseAuth.Auth.auth()
        auth.createUser(withEmail: email, password: pass) { results, error in
            guard let result = results, error == nil else {
                print("Failed to Register account")
                return
            }
            print("User created, Attempting to leav view controller")
            self.navigationController?.popViewController(animated: true)
                        
        }
    }
   
    
    
    
    func alertUserOfError(){
        print("An error occured while trying to obtain registration infromation")
    }
}
    



