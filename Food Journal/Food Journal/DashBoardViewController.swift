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
import CoreData

class DashBoardViewController: UIViewController{
    var context = ( UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var myPicturesCoreData: [UploadedPhotos] = [UploadedPhotos]()
    var newImageAdded = false
    var newImage: PictureInfo = PictureInfo()

    @IBOutlet var tableView: UITableView!
    var singlePicObject = PictureInfo()
    var dbUploadPicRef = Database.database().reference()
    var dbUploadPicRef2 = Database.database().reference()
    let dbUserRef = Database.database().reference().child("Users")
    var userSafeEmail = ""
    var totalCells = 0
    var loggedInUser: String?
   
    
    
    @IBOutlet var welcomLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        //setting up and fetching information
        loggedInUser = FirebaseAuth.Auth.auth().currentUser!.email!
        if loggedInUser == nil{
            print("Logged in user email not found")
            return
        }
        
        //tableView.isUserInteractionEnabled = false
        
        userSafeEmail = createSafeEmail(with: loggedInUser!)

        dbUserRef.child(userSafeEmail).observe(.value) { snapShot in
            var user = "Welcome "
            for child in snapShot.children{
               let ele = child as! DataSnapshot
                print(ele.key,ele.value!)
                user += ( ele.value as? String)! + " "
            }
            self.welcomLabel.text! = user
            
        }
        
        
        clearCoreData()
        getTotalObjects()
        getAllCoreData()
        if newImageAdded{
            addImage()
        }
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.hidesBackButton = true
        
  
        

        
    } //end of view did load
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    
    init(uploadedInfo: PictureInfo ,_ newImage: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        self.newImage = uploadedInfo
        self.newImageAdded = newImage
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
       
    }
    

    func addImage(){
        self.createItem(newImage)
        newImageAdded = false
    }
    
    private func getTotalObjects(){
        
        dbUploadPicRef.child("UploadedPictureData/\(userSafeEmail)").observe(.value) { snapshot in
            guard snapshot.exists() else {
                print("Child not found");
                return
                
            }

            
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                var objectNumber = 1
                
                
                 self.dbUploadPicRef2.child("UploadedPictureData/\(self.userSafeEmail)").child(snap.key).observe(.value) { snapshotFinal in
                    let lastSnap = snapshotFinal as DataSnapshot
                    var countPosition = 0   //keep track of the current key/value pair i'm working on
                    
                     for valFor in lastSnap.children{  //will loop through all the key/value pairs
                        countPosition += 1  // Description / title / urlString
                        let va = valFor as! DataSnapshot
                         switch countPosition{
                         case 1:
                             self.singlePicObject.descriptionee = va.value as! String
                             break
                         case 2:
                             self.singlePicObject.title = va.value as! String
                             break
                         default:
                             self.singlePicObject.urlString = va.value as! String
                             break
                         }
                        
                     }
                     self.createItem(self.singlePicObject)          //core data
                }
            }
            
        }
        
    
    }  // end of fromTotalObjects()
    
    
    //CORE DATA FUNCTIONS
    func getAllCoreData(){
        //
        do{
           myPicturesCoreData = try context.fetch(UploadedPhotos.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{
            print("Failed to fetch on core data")
        }
        
    }
    
    func createItem( _ picInput: PictureInfo){
         //
        print("Trying to create core data")
        
        let newItem = UploadedPhotos(context: context)
        newItem.title = picInput.title
        newItem.descript = picInput.descriptionee
        newItem.imageURL = picInput.urlString
        
        do{
            try context.save()
        }
        catch{
            print("Failed to save core data")

        }
        getAllCoreData()
    }
    
    
    func delItem(_ item: UploadedPhotos){
        print("Deleting one record in core data")
        context.delete(item)
        do{
            try context.save()
            print("Success")
            tableView.reloadData()
        }
        catch{
            print("Failed to delete core data")
        }
        
    }
    
    func clearCoreData(){
        let dele = NSBatchDeleteRequest(fetchRequest: UploadedPhotos.fetchRequest())
        do{
            try context.execute(dele)
            print("succesful delete performed")
        }
        catch{
            print("Error trying to clear data")
        }
    }

    
    
}// end of class


extension DashBoardViewController: UITableViewDelegate, UITableViewDataSource{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         print("Number of rows will be",myPicturesCoreData.count)
         return myPicturesCoreData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("The cell for row function is executing")
        
        let currentPic = myPicturesCoreData[indexPath.row] //object to be displayed on the table view
        let picInf = PictureInfo(urlString: currentPic.imageURL!, title: currentPic.title!, descriptionee: currentPic.descript!)
        let currentCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FoodTableViewCell //getting cell from table view
        
        print("Current picture data is",picInf)
        DispatchQueue.main.async {
            currentCell.setProp(picInfo: picInf) //setting the cell properties using the obbjec
        }
        return currentCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //will neeed to open image in another view controller
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            tableView.beginUpdates()
            
            // delete from core data then firebase
            //let cell = tableView.cellForRow(at: indexPath) as! FoodTableViewCell
            let UploadedPhoto = myPicturesCoreData[indexPath.row]
            print("Before deleting",myPicturesCoreData.count)
            delItem(UploadedPhoto)
            myPicturesCoreData.remove(at: indexPath.row)
            print("After deleting",myPicturesCoreData.count)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
        }
    }
}
