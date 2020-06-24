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

class TimeTableViewController: UIViewController {
    @IBOutlet var LabelStack: UIStackView!
    @IBOutlet var StartStation: UILabel!
    @IBOutlet var DestStation: UILabel!
    @IBOutlet var TrainTable: UITableView!
    
    var TimeTableList = [THSRDetail]()
    /* Received datas from ViewController for access PTX */
    var StartName = ""
    var DesName = ""
    var xdate = ""
    var authorization = ""
    /* API parameters */
    var TrainData = [Trains]()
    var TrainList = [TrainsDetail]()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        StartStation.text = StartName
        DestStation.text = DesName
        TableViewCellInit()
    }

    func TableViewCellInit() {
        let cellNib = UINib(nibName: "TimeTableTableViewCell", bundle: nil)
        TrainTable.register(cellNib, forCellReuseIdentifier: "TimeTableTableViewCell")
    }
}
/* Setup TimeTable Table values */
extension TimeTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TimeTableList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TrainTable.dequeueReusableCell(withIdentifier: "TimeTableTableViewCell", for: indexPath) as! TimeTableTableViewCell
        let Direction = TimeTableList[indexPath.row].Direction
        let TrainNo = TimeTableList[indexPath.row].TrainNo
        let Arrival = TimeTableList[indexPath.row].DepartureTime
        let Departure = TimeTableList[indexPath.row].ArrivalTime
//        let Duration = TimeTableList[indexPath.row].DepartureTime - TimeTableList[indexPath.row].ArrivalTime
        cell.setCell(Direction: Direction, TrainNo: TrainNo, Arrival: Arrival, Departure: Departure)
        return cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TrainTable.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard.init(name: "Timetable", bundle: nil)
        let DetailVC = storyboard.instantiateViewController(withIdentifier:"TimeTableDetail") as! TimeTableDetailViewController
        let DetailURL = "https://ptx.transportdata.tw/MOTC/v2/Rail/THSR/DailyTimetable/Today/TrainNo/"+TimeTableList[indexPath.row].TrainNo+"?$top=30&$format=JSON"
        let url = URL(string: DetailURL)
        var request = URLRequest(url: url!)
        request.setValue(xdate, forHTTPHeaderField: "x-date")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        URLSession.shared.dataTask(with: request){ data, response,error in
        do {
            var TempList = [TrainsDetail]()
            self.TrainData = try JSONDecoder().decode([Trains].self, from: data!)
        
            for i in 0..<self.TrainData.count {
                for j in 0..<self.TrainData[i].StopTimes.count {
                    let train = TrainsDetail()
                    train.StationName = self.TrainData[i].StopTimes[j].StationName?.Zh_tw ?? ""
                    train.DepartureTime = self.TrainData[i].StopTimes[j].Departure
                    TempList.append(train)
                    self.TrainList = TempList
                    
                    }
                }
            print(self.TrainList.count)
            DetailVC.TrainList = self.TrainList
            }
        catch{
            print(error.localizedDescription)
            }
        }.resume()
        
        
        
//        navigationController?.pushViewController(DetailVC, animated: true)
        }
        
    }
}
