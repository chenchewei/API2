//
//  RestaurantViewController.swift
//  API_2_0521
//
//  Created by mmslab-mini on 2020/6/21.
//  Copyright © 2020 mmslab-mini. All rights reserved.
//

import UIKit

class Restaurant {
    var RestName = ""
    var RestAddress = ""
    var RestDistance = 0.0
    var RestReputation = 0.0
    var RestComments = 0
}

class RestaurantViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet var RestaurantTable: UITableView!
    var RestaurantList = [Restaurant]()
    let RestURL = "https://api.bluenet-ride.com/v2_0/lineBot/restaurant/get"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "RestaurantTableViewCell", bundle: nil)
        RestaurantTable.register(cellNib, forCellReuseIdentifier: "RestaurantTableViewCell")
        RestaurantTable.delegate = self
        RestaurantTable.dataSource = self
//        RestaurantList.append(contentsOf: <#T##Sequence#>)

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
//        return RestaurantList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RestaurantTable.dequeueReusableCell(withIdentifier: "RestaurantTableViewCell", for: indexPath) as! RestaurantTableViewCell
//        cell.setCell(imgName: , RestaurantName: <#T##String#>)
        return cell
    }
    
    func getRestaurantDatas() {
        let url = URL(string: RestURL)
        var request = URLRequest(url: url!)
        
        
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
