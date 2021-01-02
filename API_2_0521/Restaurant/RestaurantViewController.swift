//
//  RestaurantViewController.swift
//  API_2_0521
//
//  Created by mmslab-mini on 2020/6/21.
//  Copyright © 2020 mmslab-mini. All rights reserved.
//

import UIKit
import MapKit
/* API Structure */
struct object: Codable {
    var results : results
}
struct results : Codable {
    var content : [content]
}
struct content : Codable {
    var lat : Double
    var lng : Double
    var name : String
    var rating : Double
    var vicinity : String   // Address
    var photo : String
    var reviewsNumber : Int
    var index : Int
}
/* Data Init */
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
    var RestPhoto = ""
}

class RestaurantViewController: UIViewController {
 
    @IBOutlet var RestaurantTable: UITableView!
    var RestaurantList = [Restaurant]()
    @IBOutlet var loadingImg: UIActivityIndicatorView!
    
    let RestURL = "https://api.bluenet-ride.com/v2_0/lineBot/restaurant/get"
    var RestaurantData : object?
    var range: Int = 2000
    
    /* Received datas from ViewController */
    var PinLat = Double()
    var PinLng = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRestaurantDatas()
        TableViewCellInit()
        // Do any additional setup after loading the view.
        barItemInit()
        self.RestaurantTable.isHidden = true
        self.loadingImg.startAnimating()
        self.loadingImg.isHidden = false
    }
    
    func TableViewCellInit() {
        let cellNib = UINib(nibName: "RestaurantTableViewCell", bundle: nil)
        RestaurantTable.register(cellNib, forCellReuseIdentifier: "RestaurantTableViewCell")
        RestaurantTable.rowHeight = 120
        RestaurantTable.estimatedRowHeight = 0
    }
    
    func barItemInit() {
        let frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let settingBarItem = UIBarButtonItem(frame: frame, imgName: "setting", target: self, action: #selector(changeDistance))
        navigationItem.rightBarButtonItem = settingBarItem
    }
    
    @objc func changeDistance() {
        let VC = ChangeDistanceDialogVC(currentDis: range)
        VC.delegate = self
        VC.dialogShow(vc: self)
    }
    
    func getRestaurantDatas() {
        let data = DataModel()
        data.lastIndex = -1
        data.count = 15
        data.type = [7]
        data.lat = PinLat
        data.lng = PinLng
        data.range = String(range)
        
        let jsonData = try? JSONEncoder().encode(data)
        let url = URL(string: RestURL)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request){ data, response,error in DispatchQueue.main.async {
            do {
                self.RestaurantData = try JSONDecoder().decode(object.self, from: data!)
                self.RestaurantTable.isHidden = false
                self.loadingImg.stopAnimating()
                self.loadingImg.isHidden = true
                self.RestaurantTable.reloadData()
                }
            catch {
                print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
}
extension RestaurantViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return RestaurantList.count
        return RestaurantData?.results.content.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RestaurantTable.dequeueReusableCell(withIdentifier: "RestaurantTableViewCell", for: indexPath) as! RestaurantTableViewCell
        
        let PinLocation = CLLocation(latitude: self.PinLat, longitude: self.PinLng)
        let TargetLocation = CLLocation(latitude: RestaurantData?.results.content[indexPath.row].lat ?? 0.0, longitude: RestaurantData?.results.content[indexPath.row].lng ?? 0.0)
        
        let img = RestaurantData?.results.content[indexPath.row].photo
        let RestNames = RestaurantData?.results.content[indexPath.row].name
        let RestAddr = RestaurantData?.results.content[indexPath.row].vicinity
        let RestDis = (TargetLocation.distance(from: PinLocation))/1000
        let RestRating = RestaurantData?.results.content[indexPath.row].rating
        let RestComments = RestaurantData?.results.content[indexPath.row].reviewsNumber

        cell.setCell(imgName: img!,RestaurantNames: RestNames!,RestaurantVicinity: RestAddr!,RestaurantDis: Float(RestDis), RestaurantRating: RestRating!,RestaurantComments:RestComments!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension RestaurantViewController: ChangeDistanceDialogVCDelegate {
    func passDistance(distance: Int) {
        removePresented {
            [weak self] in
            guard let self = self else { return }
            self.range = distance
            self.getRestaurantDatas()
            self.loadingImg.isHidden = false
            self.loadingImg.startAnimating()
        }
        
    }
    
    
}
extension UIBarButtonItem {
    convenience init(frame: CGRect, imgName: String, target: Any?, action: Selector) {
        let btn = UIButton(frame: frame)
        btn.addTarget(target, action: action, for: .touchUpInside)
        btn.setImage(UIImage(named: imgName), for: .normal)
        let barView = UIView(frame: frame)
        barView.addSubview(btn)
        self.init(customView: barView)
        
        
    }
}
