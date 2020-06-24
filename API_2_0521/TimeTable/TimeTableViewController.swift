//
//  TimeTableViewController.swift
//  API_2_0521
//
//  Created by mmslab-mini on 2020/5/28.
//  Copyright © 2020 mmslab-mini. All rights reserved.
//

import UIKit

/* API datas*/
public class THSRDetail {
    var TrainNo = ""
    var Direction = ""
    var DepartureTime = ""
    var Duration = ""   //Des-Start
    var ArrivalTime = ""
}

class TimeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var LabelStack: UIStackView!
    @IBOutlet var StartStation: UILabel!
    @IBOutlet var DestStation: UILabel!
    @IBOutlet var TrainTable: UITableView!
    
//    var THSRdata = [THSRModel]()
    
    var TimeTableList = [THSRDetail]()
//    var DetailList = [THSRDetail]()
    /* Received datas from ViewController for access PTX */
//    var TimeTableURL = ""
    var StartName = ""
    var DesName = ""
//    var xdate = ""
//    var authorization = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StartStation.text = StartName
        DestStation.text = DesName

//        getTHSRDatas()
        TrainTable.register(UITableViewCell.self, forCellReuseIdentifier: "reuseCell")
        TrainTable.delegate = self
        TrainTable.dataSource = self
//        for i in 0...TimeTableList.count{
//            print(TimeTableList[i].TrainNo)
//        }
        print(TimeTableList.count)
    }
    
    
    /* Setup TimeTable Table values */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TimeTableList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = TrainTable.dequeueReusableCell(withIdentifier: "reuseCell")
        cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "reuseCell")
        cell?.textLabel?.text = TimeTableList[indexPath.row].Direction
        cell?.detailTextLabel?.text = TimeTableList[indexPath.row].TrainNo
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    
    
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }*/
    

}
