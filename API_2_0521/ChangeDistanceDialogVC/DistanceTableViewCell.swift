//
//  DistanceTableViewCell.swift
//  API_2_0521
//
//  Created by mmslab-mini on 2021/1/2.
//  Copyright © 2021 mmslab-mini. All rights reserved.
//

import UIKit
protocol DistanceTableViewCellDelegate: class {
    func checked(cell: UITableViewCell)
}

class DistanceTableViewCell: UITableViewCell {
    @IBOutlet var label_distance: UILabel!
    @IBOutlet var btn_check: UIButton!
    
    weak var delegate: DistanceTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(dis: Int, isCheck: Bool) {
        label_distance.text = "方圓" + String(dis) + "公尺"
        btn_check.isSelected = isCheck
    }
    
    @IBAction func checkBtnClicked(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        if(sender.isSelected) {
            delegate?.checked(cell: self)
        }
        
    }
}
