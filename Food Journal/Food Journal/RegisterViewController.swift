//
//  RegisterViewController.swift
//  Food Journal
//
//  Created by IACD 015 on 2022/11/24.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    @IBOutlet var profilePicture: UIImageView!
    
    @IBOutlet var firstName: UITextField!
    @IBOutlet var emailAdd: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var lastName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //profilePicture.contentMode = .scaleAspectFit
        profilePicture.layer.cornerRadius = 12
        profilePicture.layer.borderWidth = 1
        profilePicture.layer.borderColor = UIColor.systemGreen.cgColor
        
        //creating gesture
        let gest = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        profilePicture.addGestureRecognizer(gest)
    }
    
    @objc private func didTapImage(){
        let actionSheet  = UIAlertController(title: "Profile Photo", message: "Choose Profile Option", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: {[weak self] _ in
            self?.presetPhotoGallary()
        }
                                           ))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {[weak self] _ in
            self?.presetCamera()
        }
                                           ))
        
        present(actionSheet, animated: true)
        }
    
    private func presetCamera(){
        let vc = UIImagePickerController()
        vc.allowsEditing = true
        vc.sourceType = .camera
        present(vc,animated: true)
    }
    
    private func presetPhotoGallary(){
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.sourceType = .photoLibrary
            vc.allowsEditing = true
            present(vc,animated: true)
        }
                    

    @IBAction func registerButtonTapped(_ sender: UIButton) {
        guard let fName = firstName.text, !fName.isEmpty , let lName = lastName.text, !lName.isEmpty , let email = emailAdd.text, !email.isEmpty , let pass = password.text, !pass.isEmpty
                else{
            self.alertUserOfError()
            return
        }
        
        let dbManager = DBManager()
       
        //line 73 to 78 is redundant, code along with the function must be deleted
        //line 82 is the appropriate
        dbManager.userIsFound(with: email) { userIsFound in
            guard !userIsFound else {
                print("User already exists")
                return
            }
            
            let auth = FirebaseAuth.Auth.auth()
            auth.createUser(withEmail: email, password: pass) { results, error in
                guard let result = results, error == nil else {
                    
                    print("Failed to Register account: ",error!.localizedDescription)
                    return
                }
                
                //inserting information to database
                
                dbManager.Insert(User(firstName: fName, lastName: lName, emailAddress: email))
                dbManager.Insert(User(firstName: fName, lastName: lName, emailAddress: email, profilePicture: self.profilePicture.image))
                
                self.navigationController?.popViewController(animated: true)
                            
            }
        }
        

    }
   
    
    
    
    func alertUserOfError(){
        print("An error occured while trying to obtain registration infromation")
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        self.profilePicture.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
    }
}
    



