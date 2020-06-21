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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
//        return RestaurantList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RestaurantTable.dequeueReusableCell(withIdentifier: "RestaurantTableViewCell", for: indexPath) as! RestaurantTableViewCell
        cell.textLabel?.text = "123"
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "RestaurantTableViewCell", bundle: nil)
        RestaurantTable.register(cellNib, forCellReuseIdentifier: "RestaurantTableViewCell")
        RestaurantTable.delegate = self
        RestaurantTable.dataSource = self
        

        // Do any additional setup after loading the view.
    }
}
