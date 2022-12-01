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
 
        let auth = FirebaseAuth.Auth.auth()
        
        if  auth.currentUser != nil{
            //navigationController?.pushViewController(DashBoardViewController(), animated: true)
    
            performSegue(withIdentifier: "dashboard", sender: nil)
        }
        
    }
    
    @IBAction func loginButtonTapped(_ senderB: Any) {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let auth = FirebaseAuth.Auth.auth()
            
            guard let email = emailAdd.text, !email.isEmpty , let pass = password.text, !pass.isEmpty
                    else{
                self.alertUserOfError()
                return
            }
            
            auth.signIn(withEmail: email, password: pass) { results, error in
                guard let result = results , error == nil else
                {
                    return
                }
                
               
                
                print("user signed in")
    //            let vc = DashBoardViewController()
    //            self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        performSegue(withIdentifier: "dashboard", sender: nil)
    }
    
    
    func alertUserOfError(){
        print("Failed to log in")
    }
    
}//End of body
