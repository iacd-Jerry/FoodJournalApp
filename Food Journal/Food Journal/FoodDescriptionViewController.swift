//
//  FoodDescriptionViewController.swift
//  Food Journal
//
//  Created by IACD 015 on 2022/12/03.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class FoodDescriptionViewController: UIViewController {
    var dbUploadPicRef = Database.database().reference()
    var dbUploadPicRef2 = Database.database().reference()
    var singlePicObject = PictureInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func dowloadImage(_ sender: Any) {
    
    }
    
}
