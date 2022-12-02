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
    var myPictures: [PictureInfo] = [PictureInfo] ()
    var singlePicObject = PictureInfo()
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
                    
                self.dbUploadPicRef2.child("UploadedPictureData/\(self.userSafeEmail)").child(snap.key).observe(.value) { snapshotFinal in
                    let lastSnap = snapshotFinal as DataSnapshot
                    var counter = 1
                    
                    
                    for valFor in lastSnap.children{
                        let dSnap = valFor as! DataSnapshot
                        let val = dSnap.value!
                        switch counter{
                        case 1:
                            self.singlePicObject.descriptionee = val as! String
                            break
                        case 2:
                            self.singlePicObject.title = val as! String
                            break
                        default:
                            self.singlePicObject.urlString = val as! String
                        }
                        counter += 1
                    }
                    //self.myPictures.append(self.singlePicObject)
                    self.addObject(self.singlePicObject)
                }
               
                }
            
            }
            print("After view did load, pictures are \(myPictures.count)")
        }
    
    private func addObject(_ picInformation: PictureInfo){
        myPictures.append(picInformation)
        print(myPictures)
        print("Total picures",myPictures.count)
        print(myPictures[myPictures.count-1])
    }
    
}


    func loadVideos() -> [Video]{
        var videoArr = [Video]()
        for i in 1...6{
            videoArr.append(Video(img: UIImage(named: "dice\(i).png")!, title: "Dice\(i)" ,description: "This is Dice\(i)"))
        }
        return videoArr
    }
    



extension DashBoardViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Pictures in total \(myPictures.count)")
        return myVideos.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let selectedVideo = myVideos[indexPath.row]
        let currentCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FoodTableViewCell
        
        currentCell.setProp(video: selectedVideo)
        return currentCell
    }
    
}
