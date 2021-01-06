//
//  RestaurantTableDetailVC.swift
//  API_2_0521
//
//  Created by mmslab406-mini2018-2 on 2021/1/6.
//  Copyright © 2021 mmslab-mini. All rights reserved.
//

import UIKit

class RestaurantTableDetailVC: UIViewController {
    @IBOutlet var tableView: UITableView!
    var stationLat: Double = 0.0
    var stationLng: Double = 0.0
    var endLat: Double = 0.0
    var endLng: Double = 0.0
    var data = [review]()
    
    convenience init(stationLat: Double, stationLng: Double, endLat: Double, endLng: Double, data: [review]) {
        self.init()
        self.stationLat = stationLat
        self.stationLng = stationLng
        self.endLat = endLat
        self.endLng = endLng
        self.data = data
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barItemInit()
        title = "餐廳詳細資訊"
        TableViewCellInit()
    }
    
    func TableViewCellInit() {
        let cellNib = UINib(nibName: "RestaurantTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "RestaurantTableViewCell")
    }

    func barItemInit() {
        let frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let settingBarItem = UIBarButtonItem(frame: frame, imgName: "Guide", target: self, action: #selector(GuideBtnClicked))
        navigationItem.rightBarButtonItem = settingBarItem
    }
    
    @objc func GuideBtnClicked() {
        let url = "http://maps.google.com/maps?f=d&saddr=\(stationLat)%20\(stationLng)&daddr=\(endLat)%20\(endLng)&hl=en"
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }

}

extension RestaurantTableDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantTableViewCell", for: indexPath) as! RestaurantTableViewCell
        
        cell.setDetailCell(imgName: data[indexPath.row].photo, name: data[indexPath.row].name, comment: data[indexPath.row].text, rating: data[indexPath.row].rating)
        
        return cell
    }
    
    
}
