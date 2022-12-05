//
//  extensions and methods.swift
//  Food Journal
//
//  Created by IACD 015 on 2022/11/24.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

struct User{
    //academicsafe@gmail.com
    var firstName: String
    var lastName: String
    var emailAddress: String
    var emailForChild: String {
        var newEmail = emailAddress
            newEmail = newEmail.replacingOccurrences(of: ".", with: "_")
            newEmail = newEmail.replacingOccurrences(of: "@", with: "_")
            newEmail = newEmail.replacingOccurrences(of: "$", with: "_")
            newEmail = newEmail.replacingOccurrences(of: "%", with: "_")
            return newEmail
    }
    var profilePicture: UIImage?
    var uploadedImages : [UIImage]?
    var uploads: [String: String]?
}

struct PictureInfo{
    var urlString: String
    var title: String
    var descriptionee: String
    
    init (urlString: String, title: String, descriptionee: String){
        self.urlString = urlString
        self.title = title
        self.descriptionee = descriptionee
    }
    
    init(){
        urlString = ""
        title = ""
        descriptionee = ""
    }
}

final class DBManager{
    var auth = FirebaseAuth.Auth.auth()
    let dbReference = Database.database().reference()
    let dbStorageReferemce = Storage.storage().reference()
    
    func userIsFound(with email: String, completion: @escaping ((Bool) -> Void) ){
        var newEmail = email
            newEmail = newEmail.replacingOccurrences(of: ".", with: "_")
            newEmail = newEmail.replacingOccurrences(of: "@", with: "_")
            newEmail = newEmail.replacingOccurrences(of: "$", with: "_")
            newEmail = newEmail.replacingOccurrences(of: "%", with: "_")
        
        dbReference.child(newEmail).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else{
                completion(false)
                return
            }
            completion(true)
        }
        
    }
    
    func Insert(_ user: User){
        dbReference.child("Users").child(user.emailForChild).setValue(["firstName": user.firstName,
                                                                       "lastName": user.lastName
                                                                       ])
        guard let imgData = user.profilePicture?.pngData() else {
            print("Failed to convert image to png")
            return
        }
        
        dbStorageReferemce.child("UserProfilePictures").child(user.emailForChild).putData(imgData, metadata: nil) { _, error in
            guard  error == nil else {
                print("Something went wrong while trying to store image in storage")
                return
            }
                        
        }
        
    }  //end of insert function
    
    
    func record(pictureInfo: PictureInfo , emailAsChild: String, imgName: String){
        print("Child name to be used on database: \(imgName)")
        
        dbReference.child("UploadedPictureData").child(emailAsChild).child(imgName).setValue(
                         [
                        "UrlString": pictureInfo.urlString,
                        "Title": pictureInfo.title,
                        "Description": pictureInfo.descriptionee
                            ])
        
    }  //end of insert function
    
    func deleteChild( uploadedImage: UploadedPhotos, emailAsChild: String){
        print("the child key is",uploadedImage.childKey!)
        dbReference.child("UploadedPictureData").child(emailAsChild).child(uploadedImage.childKey!).setValue(nil)
        dbStorageReferemce.child("Uploaded Images/\(emailAsChild)").child(uploadedImage.childKey!).delete { error in
                guard error == nil else {print("Error while trying to delete photo from storage"); return}
                print("Succesfully deleted child from storage")
        }
      
    }  //end of delete function
    
    
    func signedUser()-> Bool{
        
        var managed = false
        do{
            try auth.signOut()
            managed = true
        }
        catch{
            print("Failed to signout user")
        }
        return managed
    }
    
}


class Video{
    var img: UIImage
    var title: String
    var foodDescription: String

    init(img: UIImage, title: String , description : String){
        self.img = img
        self.title = title
        self.foodDescription = description
    }
    
}

func createSafeEmail(with email: String) ->String{
    
        var newEmail = email
            newEmail = newEmail.replacingOccurrences(of: ".", with: "_")
            newEmail = newEmail.replacingOccurrences(of: "@", with: "_")
            newEmail = newEmail.replacingOccurrences(of: "$", with: "_")
            newEmail = newEmail.replacingOccurrences(of: "%", with: "_")
            return newEmail
}

func createChild(with givenString: String) ->String{
    
        var newEmail = givenString
            newEmail = newEmail.replacingOccurrences(of: ".", with: " ")
            //newEmail = newEmail.replacingOccurrences(of: "-", with: "D")
            //newEmail = newEmail.replacingOccurrences(of: ":", with: "C")
            //newEmail = newEmail.replacingOccurrences(of: ",", with: "P")
            newEmail = newEmail.replacingOccurrences(of: "/", with: " ")
            return newEmail
}
