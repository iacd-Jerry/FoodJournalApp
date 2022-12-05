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
    let dbManager = DBManager()

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
        print(dbManager.auth.currentUser?.email)
        
        let auth = FirebaseAuth.Auth.auth()
        print(auth.currentUser?.email)
        
        loggedInUser = auth.currentUser!.email!
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

    
    init(uploadedInfo: PictureInfo ,_ newImage: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        self.newImage = uploadedInfo
        self.newImageAdded = newImage
        clearCoreData()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    

    func addImage(){
        self.createItem(newImage, "not Provided yet")
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
                     print("Key name for the below pictures is",snap.key)
                     self.createItem(self.singlePicObject ,  snap.key)          //core data
                }
            }
            
        }
    }  // end of fromTotalObjects()
    
    
    //CORE DATA FUNCTIONS
    func getAllCoreData(){
        //
        do{
           myPicturesCoreData = try context.fetch(UploadedPhotos.fetchRequest())
           self.tableView.reloadData()
        }
        catch{
            print("Failed to fetch on core data")
        }
        
    }
    
    func createItem( _ picInput: PictureInfo , _ childKey: String){
         //
        print("Trying to create core data")
        
        let newItem = UploadedPhotos(context: context)
        newItem.title = picInput.title
        newItem.descript = picInput.descriptionee
        newItem.imageURL = picInput.urlString
        newItem.childKey = childKey
        
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
        context.delete(item as NSManagedObject)
        do{
            try context.save()
            print("Success")
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

    
    @IBAction func signOutUser(_ sender: Any) {
        let alertSheet  = UIAlertController(title: "Confirm Logout", message: "Do you wish to logout", preferredStyle: .alert)
        alertSheet.addAction(UIAlertAction(title: "Yes", style: .default, handler: {[weak self] _ in
            _ = self?.dbManager.signedUser()
            self?.navigationController?.popViewController(animated: true)
        }))
        
        alertSheet.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        present(alertSheet, animated: true)
        }
    
}// end of class


extension DashBoardViewController: UITableViewDelegate, UITableViewDataSource{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         print("Executing number of row in section")
         return myPicturesCoreData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Executing cell for row at")
        
        let currentPic = myPicturesCoreData[indexPath.row] //object to be displayed on the table view
        let picInf = PictureInfo(urlString: currentPic.imageURL!, title: currentPic.title!, descriptionee: currentPic.descript!)
        let currentCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FoodTableViewCell //getting cell from table view

            currentCell.setProp(picInfo: picInf) //setting the cell properties using the obbjec
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
            
            
            // delete from core data then firebase
            //let cell = tableView.cellForRow(at: indexPath) as! FoodTableViewCell
            let Uploaded = myPicturesCoreData[indexPath.row]
            print("The name of the image to be deleted is ",Uploaded.childKey!," with key",Uploaded.childKey!)
            
            DispatchQueue.main.async { [self] in
                tableView.beginUpdates()
                dbManager.deleteChild(uploadedImage: Uploaded, emailAsChild: userSafeEmail)
                delItem(Uploaded)
                myPicturesCoreData.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }
            
        }
    }
}
