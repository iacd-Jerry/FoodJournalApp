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
    
    
    func setProp(video: Video){
        foodTitle!.text = video.title
        foodDescription!.text = video.foodDescription
        foodImage!.image = video.img
    }
    
}
