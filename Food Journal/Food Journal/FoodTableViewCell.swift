//
//  FoodTableViewCell.swift
//  Food Journal
//
//  Created by IACD 0q15 on 2022/11/30.
//

import UIKit

class FoodTableViewCell: UITableViewCell {
    @IBOutlet var foodImage: UIImageView!
    @IBOutlet var foodDescription: UILabel!
    @IBOutlet var foodTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
}
