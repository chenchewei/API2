//
//  RestaurantTableViewCell.swift
//  API_2_0521
//
//  Created by mmslab-mini on 2020/6/21.
//  Copyright © 2020 mmslab-mini. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet var RestaurantImage: UIImageView!
    @IBOutlet var RestaurantName: UILabel!
    @IBOutlet var RestaurantAddress: UILabel!
    @IBOutlet var RestaurantDistance: UILabel!
    @IBOutlet var RestaurantReputation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(imgName: String,RestaurantNames: String,RestaurantVicinity: String,RestaurantDis: Double, RestaurantRating: Double) {
        RestaurantImage.image = UIImage(contentsOfFile: imgName)
        RestaurantName.text = RestaurantNames
        RestaurantAddress.text = RestaurantVicinity
        RestaurantDistance.text = String(RestaurantDis) + "km away from your location"
        RestaurantReputation.text = String(RestaurantRating)        
    }
    
    
    
    
}
