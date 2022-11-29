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
}

final class DBManager{
    
    let dbReference = Database.database().reference()
    
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
        
    }
}
