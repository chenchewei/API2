//
//  TimeTableViewController.swift
//  API_2_0521
//
//  Created by mmslab-mini on 2020/5/28.
//  Copyright © 2020 mmslab-mini. All rights reserved.
//

import UIKit
/* THSR TrainNo data structure */
struct Trains: Codable {
    var StopTimes : [StopTimes]
}
struct StopTimes : Codable {
    var StationName : StationName?
    var DepartureTime : String?
}
struct StationName : Codable {
    var Zh_tw : String?
    var En : String?
}
/* API datas*/
public class THSRDetail {
    var TrainNo = ""
    var Direction = ""
    var DepartureTime = ""
    var Duration = ""   //Des-Start
    var ArrivalTime = ""
}
public class TrainsDetail {
    var StationName = ""
    var DepartureTime = ""
}

class TimeTableViewController: UIViewController {
    @IBOutlet var LabelStack: UIStackView!
    @IBOutlet var StartStation: UILabel!
    @IBOutlet var DestStation: UILabel!
    @IBOutlet var TrainTable: UITableView!
    /* Received datas from ViewController for access PTX */
    var StartName = ""
    var DesName = ""
    var xdate = String()
    var authorization = String()
    var TimeTableList = [THSRDetail]()
    /* API parameters */
    var TrainData = [Trains]()
    var TrainList = [TrainsDetail]()

    override func viewDidLoad() {
        super.viewDidLoad()
        StartStation.text = StartName
        DestStation.text = DesName
        TableViewInit()
        barItemInit()
        title = "時刻表"
    }

    func TableViewInit() {
        let cellNib = UINib(nibName: "TimeTableTableViewCell", bundle: nil)
        TrainTable.register(cellNib, forCellReuseIdentifier: "TimeTableTableViewCell")
        TimeTableListSort()
    }
    
    func barItemInit() {
        let frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let settingBarItem = UIBarButtonItem(frame: frame, imgName: "booking", target: self, action: #selector(bookingBtnClicked))
        navigationItem.rightBarButtonItem = settingBarItem
    }
    
    @objc func bookingBtnClicked() {
        if let url = URL(string: "https://irs.thsrc.com.tw/IMINT/?locale=tw") {
            UIApplication.shared.open(url)
        }
    }
        
    
    
    func TimeTableListSort() {
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "HH:mm"
        TimeTableList.sort { (data1, data2) -> Bool in
        //            print(data1.DepartureTime,"---",data2.DepartureTime)
        //            guard let date1 = dateFormatter.date(from: data1.DepartureTime) else {print("ordered failed", data1.DepartureTime); return false}
        //            guard let date2 = dateFormatter.date(from: data2.DepartureTime) else {print("ordered failed",data2.DepartureTime); return false}
        //            let result =  date1.compare(date2)
        let result =  data1.DepartureTime.compare(data2.DepartureTime)
        switch result {
            case .orderedAscending:
//                print("ordered Ascending")
                return true
            default:
//                print("Sorted default")
                return false
            }
        }
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
        
        let DepartureTimes = TimeTableList[indexPath.row].DepartureTime.split(separator: ":")
        let ArrivalTimes = TimeTableList[indexPath.row].ArrivalTime.split(separator: ":")
        
        let Duration = (Int(ArrivalTimes[0])!-Int(DepartureTimes[0])!)*60 + (Int(ArrivalTimes[1])!-Int(DepartureTimes[1])!)
        cell.setCell(Direction: Direction, TrainNo: TrainNo, Arrival: Arrival, Departure: Departure,Duration: String(Duration))
        cell.backgroundColor = UIColor(hexStr: "#ECF5FF")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TrainTable.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let DetailVC = storyboard.instantiateViewController(withIdentifier:"TimeTableDetail") as! TimeTableDetailViewController
        let DetailURL = "https://ptx.transportdata.tw/MOTC/v2/Rail/THSR/DailyTimetable/Today/TrainNo/"+TimeTableList[indexPath.row].TrainNo+"?$top=30&$format=JSON"

        let url = URL(string: DetailURL)
        var request = URLRequest(url: url!)
        request.setValue(xdate, forHTTPHeaderField: "x-date")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        
        URLSession.shared.dataTask(with: request){ data, response,error in do {
            self.TrainList.removeAll()
            self.TrainData = try JSONDecoder().decode([Trains].self, from: data!)
            for j in 0..<self.TrainData[0].StopTimes.count {
                let train = TrainsDetail()
                train.StationName = self.TrainData[0].StopTimes[j].StationName?.Zh_tw ?? ""
                train.DepartureTime = self.TrainData[0].StopTimes[j].DepartureTime ?? "終點站"
                self.TrainList.append(train)
            }
            DispatchQueue.main.async {  // Wait until datas received
                DetailVC.TrainList = self.TrainList
                DetailVC.StartStation = self.StartName
                DetailVC.DestinationStation = self.DesName
                self.navigationController?.pushViewController(DetailVC, animated: true)
            }
        }
        catch{
            DispatchQueue.main.async {
                 self.view.makeToast(error.localizedDescription)
            }
            }
        }.resume()
       
    }
}
