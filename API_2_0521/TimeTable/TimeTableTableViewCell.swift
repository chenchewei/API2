//
//  TimeTableTableViewCell.swift
//  API_2_0521
//
//  Created by mmslab-mini on 2020/6/24.
//  Copyright © 2020 mmslab-mini. All rights reserved.
//

import UIKit

class TimeTableTableViewCell: UITableViewCell {

    @IBOutlet var DirectionLabel: UILabel!
    @IBOutlet var TrainNoLabel: UILabel!
    @IBOutlet var ArrivalLabel: UILabel!
    @IBOutlet var DepartureLabel: UILabel!
    @IBOutlet var DurationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setCell(Direction:String,TrainNo:String,Arrival:String,Departure:String,Duration:String) {
        DirectionLabel.text = Direction
        TrainNoLabel.text = TrainNo
        ArrivalLabel.text = Arrival
        DepartureLabel.text = Departure
        DurationLabel.text = Duration + "mins"
    }
    
}
