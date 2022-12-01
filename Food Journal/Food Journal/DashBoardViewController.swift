//
//  DashBoardViewController.swift
//  Food Journal
//
//  Created by IACD 015 on 2022/11/24.
//

import UIKit
import FirebaseAuth

class DashBoardViewController: UIViewController{
    @IBOutlet var tableView: UITableView!
    var myVideos: [Video] = [Video]()
    var counter = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .link
        navigationItem.hidesBackButton = true
        myVideos = loadVideos()
        
        tableView.dataSource = self
        tableView.delegate = self
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
