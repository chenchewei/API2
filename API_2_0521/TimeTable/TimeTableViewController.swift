//
//  TimeTableViewController.swift
//  API_2_0521
//
//  Created by mmslab-mini on 2020/5/28.
//  Copyright © 2020 mmslab-mini. All rights reserved.
//

import UIKit



class TimeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var LabelStack: UIStackView!
    @IBOutlet var StartStation: UILabel!
    @IBOutlet var DestStation: UILabel!
    
    
    
    @IBOutlet var TrainTable: UITableView!
    
    var THSRdata = [THSRModel]()
    
    var TimeTableURL = ""
    var StartName = ""
    var DesName = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TrainTable.register(UITableViewCell.self, forCellReuseIdentifier: "reuseCell")
        print(TimeTableURL)
        StartStation.text = StartName
        DestStation.text = DesName
    }
    /* Setup TimeTable Table values */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 16
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellA = TrainTable.dequeueReusableCell(withIdentifier: "reuseCell",for: indexPath)
        cellA.textLabel?.text = String(format: "%d cell",indexPath.row)
        
        return cellA
        
    }
    
    
    
    
    
    
    
    
    
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }*/
    

}
