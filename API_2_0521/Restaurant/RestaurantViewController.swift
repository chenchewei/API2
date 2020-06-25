//
//  RestaurantViewController.swift
//  API_2_0521
//
//  Created by mmslab-mini on 2020/6/21.
//  Copyright © 2020 mmslab-mini. All rights reserved.
//

import UIKit

class DataModel : Codable {
    var lastIndex = -1
    var count = 0
    var type = [7]
    var lat = Double()
    var lng = Double()
    var range = String()
}


class Restaurant {
    var RestName = ""
    var RestAddress = ""
    var RestDistance = 0.0
    var RestReputation = 0.0
    var RestComments = 0
}

class RestaurantViewController: UIViewController {
 
    @IBOutlet var RestaurantTable: UITableView!
    var RestaurantList = [Restaurant]()
    let RestURL = "https://api.bluenet-ride.com/v2_0/lineBot/restaurant/get"
    
    /* Received datas from ViewController */
    var PinLat = Double()//[0.0,0.0]  // [Lat,Lng]
    var PinLng = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableViewCellInit()
        getRestaurantDatas()
        // Do any additional setup after loading the view.
    }
    func TableViewCellInit() {
        let cellNib = UINib(nibName: "RestaurantTableViewCell", bundle: nil)
        RestaurantTable.register(cellNib, forCellReuseIdentifier: "RestaurantTableViewCell")
        RestaurantTable.rowHeight = 120
        RestaurantTable.estimatedRowHeight = 0
    }

    
    func getRestaurantDatas() {
        let data = DataModel()
        data.lastIndex = -1
        data.count = 15
        data.type = [7]
        data.lat = PinLat
        data.lng = PinLng
        data.range = "1000"
        let jsonData = try? JSONEncoder().encode(data)
        
        let url = URL(string: RestURL)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request){ data, response,error in
        do {
            var ApiDataList = [Restaurant]()
            
            
            
            
            
            }
        catch {
            print(error)
            }
        }
        task.resume()
        
        
    }
    
    
}
extension RestaurantViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
//        return RestaurantList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RestaurantTable.dequeueReusableCell(withIdentifier: "RestaurantTableViewCell", for: indexPath) as! RestaurantTableViewCell
//        cell.setCell(imgName: , RestaurantName: <#T##String#>)
        return cell
    }
}
