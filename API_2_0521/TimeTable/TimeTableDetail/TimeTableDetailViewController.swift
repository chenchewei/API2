//
//  TimeTableDetailViewController.swift
//  API_2_0521
//
//  Created by mmslab-mini on 2020/5/31.
//  Copyright © 2020 mmslab-mini. All rights reserved.
//

import UIKit

class TimeTableDetailViewController: UIViewController {
    @IBOutlet var DetailTable: UITableView!
    /* Received datas */
    var TrainList = [TrainsDetail]()
    var StartStation = ""
    var DestinationStation = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableViewCellInit()
    }
    func TableViewCellInit() {
        let cellNib = UINib(nibName: "DetailTableViewCell", bundle: nil)
        DetailTable.register(cellNib, forCellReuseIdentifier: "DetailTableViewCell")
    }
}

extension TimeTableDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TrainList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DetailTable.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
        let StationName = TrainList[indexPath.row].StationName
        let DepartureTime = TrainList[indexPath.row].DepartureTime
        cell.setCell(Station:StationName,Time:DepartureTime)
        // Set Background Color
        if(cell.StationLabel.text == StartStation || cell.StationLabel.text == DestinationStation){
            cell.backgroundColor = .orange
        }
        else {
            cell.backgroundColor = .systemGray5
        }
        return cell
    }
}
