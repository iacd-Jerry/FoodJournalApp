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

    @IBAction func loginButtonTapped(_ sender: Any) {
        let auth = FirebaseAuth.Auth.auth()
        
        guard let email = emailAdd.text, !email.isEmpty , let pass = password.text, !pass.isEmpty
                else{
            self.alertUserOfError()
            return
        }
        
        auth.signIn(withEmail: email, password: password, completion: <#T##((AuthDataResult?, Error?) -> Void)?##((AuthDataResult?, Error?) -> Void)?##(AuthDataResult?, Error?) -> Void#>)
    }
    
    
    func alertUserOfError(){
        print("An error occured while trying to obtain registration infromation")
    }
    
}//End of body
