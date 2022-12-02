//
//  DashBoardViewController.swift
//  Food Journal
//
//  Created by IACD 015 on 2022/11/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class DashBoardViewController: UIViewController{
    @IBOutlet var tableView: UITableView!
    var myVideos: [Video] = [Video]()
    var myPictures = [PictureInfo] ()
    var dbUploadPicRef = Database.database().reference()
    var dbUploadPicRef2 = Database.database().reference()
    let dbUserRef = Database.database().reference().child("Users")
    var userSafeEmail = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.hidesBackButton = true
        myVideos = loadVideos()
        
        //setting up and fetching information
        userSafeEmail = createSafeEmail(with: FirebaseAuth.Auth.auth().currentUser!.email!)
        
        //print(userSafeEmail)
        dbUploadPicRef.child("UploadedPictureData/\(userSafeEmail)").observe(.value) { snapshot in
            guard snapshot.exists() else { print("Child not found"); return}
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                
                self.dbUploadPicRef2.child(self.userSafeEmail).child(snap.key).observe(.value) { snapshot2 in
                    //here trying to fix the Parent/ child hierachy
                    print("Reached the second inner child")
                }
            }
        }
        
    }
    
    
    func loadVideos() -> [Video]{
        var videoArr = [Video]()
        for i in 1...6{
            videoArr.append(Video(img: UIImage(named: "dice\(i).png")!, title: "Dice\(i)" ,description: "This is Dice\(i)"))
        }
        return videoArr
    }
    

}

extension DashBoardViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Total number of videos will be \(myVideos.count)")
        return myVideos.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let selectedVideo = myVideos[indexPath.row]
        let currentCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FoodTableViewCell
        
        currentCell.setProp(video: selectedVideo)
        return currentCell
    }
    
}
