//
//  FoodTableViewCell.swift
//  Food Journal
//
//  Created by IACD 0q15 on 2022/11/30.
//

import UIKit

class FoodTableViewCell: UITableViewCell {
    @IBOutlet var foodImage: UIImageView?
    @IBOutlet var foodDescription: UILabel?
    @IBOutlet var foodTitle: UILabel?
    
    
    func setProp(picInfo: PictureInfo){
        foodTitle!.text = picInfo.title
        foodDescription!.text = picInfo.descriptionee
        
            guard let url = URL(string: picInfo.urlString) else {print("Invalid URL");  return }
            if let dataImage = try? Data(contentsOf: url){
                self.foodImage!.image = UIImage(data: dataImage)
            }else{
                print("Error downloading image")
                return
        }
        
    }
}
