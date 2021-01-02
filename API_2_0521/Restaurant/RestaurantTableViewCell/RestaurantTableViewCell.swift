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
    
    func setCell(imgName: String,RestaurantNames: String,RestaurantVicinity: String,RestaurantDis: Float, RestaurantRating: Double,RestaurantComments: Int) {
        if let imgurl = URL(string: imgName) {
            DispatchQueue.main.async {
                do{
                    let imgData = try Data(contentsOf: imgurl)
                    let newimg = UIImage(data: imgData)
                    self.RestaurantImage.image = newimg
                }
                catch{
                    print(error.localizedDescription)
                }
            }
        }
        RestaurantName.text = RestaurantNames
        RestaurantAddress.text = RestaurantVicinity
        
        if(RestaurantDis < 1) {
            let RestaurantDisMeter = RestaurantDis*1000
            RestaurantDistance.text = String(format: "%d", RestaurantDisMeter) + "m"
        } else {
            RestaurantDistance.text = String(format: "%.2f",RestaurantDis) + "km"
        }
        RestaurantReputation.text = "評價："+String(RestaurantRating)+"("+String(RestaurantComments)+" 則評論)"
        RestaurantReputation.textColor = .darkGray
    }
 
}
