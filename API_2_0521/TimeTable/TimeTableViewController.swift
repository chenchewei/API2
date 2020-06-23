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
    
    var THSRdata = [THSRModel]()
    
    var TimeTableList = [THSRDetail]()
    var TempList = [THSRDetail]()
    /* Received datas from ViewController for access PTX */
    var TimeTableURL = ""
    var StartName = ""
    var DesName = ""
    var xdate = ""
    var authorization = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TrainTable.register(UITableViewCell.self, forCellReuseIdentifier: "reuseCell")
        StartStation.text = StartName
        DestStation.text = DesName
        TrainTable.delegate = self
        TrainTable.dataSource = self
        getTHSRDatas()
        TempList = TimeTableList
    }
    /* Setup TimeTable Table values */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TempList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TrainTable.dequeueReusableCell(withIdentifier: "reuseCell",for: indexPath)
        cell.textLabel?.text = TempList[indexPath.row].Direction
        cell.detailTextLabel?.text = TempList[indexPath.row].TrainNo
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        navigationController?.popViewController(animated: true)
    }
    
    func getTHSRDatas() {
        let url = URL(string: TimeTableURL)
        var request = URLRequest(url: url!)
        request.setValue(xdate, forHTTPHeaderField: "x-date")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        URLSession.shared.dataTask(with: request){ data, response,error in
        do {
            var DecodedDataList = [THSRDetail]()
            self.THSRdata = try JSONDecoder().decode([THSRModel].self, from: data!)
            for i in 0..<self.THSRdata.count {
                let timeTable = THSRDetail()
                if(self.THSRdata[i].DailyTrainInfo?.Direction == 0) {
                    timeTable.Direction = "南下"
                    }
                else{
                    timeTable.Direction = "北上"
                    }
                timeTable.TrainNo = self.THSRdata[i].DailyTrainInfo?.TrainNo ?? ""
                timeTable.DepartureTime = self.THSRdata[i].OriginStopTime?.ArrivalTime ?? ""
                timeTable.ArrivalTime = self.THSRdata[i].DestinationStopTime?.ArrivalTime ?? ""
                DecodedDataList.append(timeTable)
                self.TimeTableList = DecodedDataList
//                print(self.TimeTableList[i].TrainNo)
                }
            }
        catch {
            print(error)
            }
        }.resume()
//        for i in 0...TimeTableList.count{
//            print(TimeTableList[i].ArrivalTime)
//        }

    }
    
    
    
    
    
    
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }*/
    

}
