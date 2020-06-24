//
//  DetailTableViewCell.swift
//  API_2_0521
//
//  Created by mmslab-mini on 2020/6/24.
//  Copyright © 2020 mmslab-mini. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet var StationLabel: UILabel!
    @IBOutlet var TimeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setCell(Station:String,Time:String){
        StationLabel.text = Station
        TimeLabel.text = Time
    }
    
}
