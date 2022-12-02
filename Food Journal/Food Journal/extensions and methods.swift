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
}

final class DBManager{
    
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
        print("This is the child name",imgName)
        dbReference.child("UploadedPictureData").child(emailAsChild).child(imgName).setValue(
                         [
                        "UrlString": pictureInfo.urlString,
                        "Title": pictureInfo.title,
                        "Description": pictureInfo.descriptionee
                            ])
        
    }  //end of insert function
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
