//
//  PictureUploadViewController.swift
//  Food Journal
//
//  Created by IACD 015 on 2022/12/01.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import FirebaseFirestore

class PictureUploadViewController: UIViewController {
    @IBOutlet var foodDescription: UITextField!
    @IBOutlet var foodTitle: UITextField!
    @IBOutlet var uploadPicture: UIImageView!
    var currentUserEmail: String?
    let dbmanager = DBManager()
    var currentDate = Date()
    var imageName = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadPicture.contentMode = .scaleAspectFit
        uploadPicture.layer.cornerRadius = 15
        uploadPicture.layer.borderWidth = 1
        uploadPicture.layer.borderColor = UIColor.systemGreen.cgColor

        let gest = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        uploadPicture.addGestureRecognizer(gest)
        
        currentUserEmail = FirebaseAuth.Auth.auth().currentUser!.email!
        
    }
    
    @objc private func didTapImage(){
        print("Image tapped")
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
    
    
    @IBAction func uploadButtonTapped(_ sender: UIButton) {
        
        guard let imageData = uploadPicture.image?.pngData() , let description = foodDescription.text , let foodTitle = foodTitle.text else{
            print("Failed to receive all information for uploading picture")
            return
        }//end of guard
        
        let safeEmail = createSafeEmail(with: currentUserEmail!)
        
        //generating random name for the image to be uploaded...to get the date part, separater is -
        self.imageName  =  createChild(with: self.currentDate.formatted()+"-"+String( Calendar.current.component(.second, from: self.currentDate))+".png")
       
        let dbStorage = FirebaseStorage.Storage.storage().reference().child("Uploaded Images/\(safeEmail)")
        
        dbStorage.child(imageName).putData(imageData) { _ , error in
            print("Uploading image")
            guard error == nil else {
                print("Failed to upload image")
                return
            }// end of guard
            
            print("Trying to get URL For downloading")
            
            
            dbStorage.child(self.imageName).downloadURL { url, error in
                guard error == nil else { print("Error getting Url");  return }
                let urlString = url?.absoluteString
                print("Donwload URL: ",urlString!)
                
               let picInfo = PictureInfo(urlString: urlString!, title: foodTitle, descriptionee: description)
                //here now
                
                //Start here, imgName below causes a crash because it has slashes
                //"12/2/2022, 12:25 AM-49.png", code on the extensions needs to be updated
               // so imgName is not a path
                self.dbmanager.record(pictureInfo: picInfo, emailAsChild: createSafeEmail(with: self.currentUserEmail!) , imgName: createChild(with: self.imageName))
            }

        }
        
        dismiss(animated: true)
        
    }//end of upload button tapped
    
    
}

extension PictureUploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        self.uploadPicture.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
       
    }
}
  
/**
 let safeEmail = createSafeEmail(with: currentUserEmail!)
 
 //generating random name for the image to be uploaded...to get the date part, separater is -
 let currentDate = Date()
 let imageName  =  currentDate.formatted()+"-"+String( Calendar.current.component(.second, from: currentDate))+".png"
 let dbStorage = FirebaseStorage.Storage.storage().reference().child("Uploaded Images/\(safeEmail)")
 
 dbStorage.child(imageName).putData(imageData) { _ , error in
     guard error == nil else {
         print("Failed to upload image")
         return
     }// end of guard
     
     
     
 }
 
 */
