//
//  TimeTableDetailViewController.swift
//  API_2_0521
//
//  Created by mmslab-mini on 2020/5/31.
//  Copyright © 2020 mmslab-mini. All rights reserved.
//

import UIKit

public class TrainsDetail {
    var StationName = ""
    var DepartureTime = ""
}

class TimeTableDetailViewController: UIViewController {

    @IBOutlet var DetailTable: UITableView!
    /* Received datas */
    var TrainList = [TrainsDetail]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        for i in TrainList.count {
//            print(TrainList)
//        }
        // Do any additional setup after loading the view.
    }
    
}
