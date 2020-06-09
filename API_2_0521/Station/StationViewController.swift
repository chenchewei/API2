//
//  StationViewController.swift
//  API_2_0521
//
//  Created by mmslab-mini on 2020/5/28.
//  Copyright © 2020 mmslab-mini. All rights reserved.
//

import UIKit

class StationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var StationTable: UITableView!
    /* Search bar settings*/
    var searchController: UISearchController!
    var resultAddress = [String]()
    var shouldShowResult = false    // flag
    /* Station datas */
    var Stations = ["台北市南港區南港路一段313號":"南港","台北市北平西路3號":"台北","新北市板橋區縣民大道二段7號":"板橋","桃園市中壢區高鐵北路一段6號":"桃園","新竹縣竹北市高鐵七路6號":"新竹","苗栗縣後龍鎮高鐵三路268號":"苗栗","台中市烏日區站區二路8號":"台中","彰化縣田中鎮站區路二段99號":"彰化","雲林縣虎尾鎮站前東路301號":"雲林","嘉義縣太保市高鐵西路168號":"嘉義","台南市歸仁區歸仁大道100號":"台南","高雄市左營區高鐵路105號":"左營"]
        /* For init data */
    var StationNameArr = ["南港","台北","板橋","桃園","新竹","苗栗","台中","彰化","雲林","嘉義","台南","左營"]
    var StationAddressArr = ["台北市南港區南港路一段313號","台北市北平西路3號","新北市板橋區縣民大道二段7號","桃園市中壢區高鐵北路一段6號","新竹縣竹北市高鐵七路6號","苗栗縣後龍鎮高鐵三路268號","台中市烏日區站區二路8號","彰化縣田中鎮站區路二段99號","雲林縣虎尾鎮站前東路301號","嘉義縣太保市高鐵西路168號","台南市歸仁區歸仁大道100號","高雄市左營區高鐵路105號"]
/* Pre load */
    override func viewDidLoad() {
        super.viewDidLoad()
        StationTable.register(UITableViewCell.self, forCellReuseIdentifier: "reuseCell")
        StationTable.delegate = self
        StationTable.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
/* Main */
    /* Search and filter stations*/
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == ""){
            shouldShowResult = false
        }
        else{
            shouldShowResult = true
        }
        resultAddress = Stations.keys.filter({ (TempAddress) -> Bool in
            let AddressTempText: String = TempAddress
            return (AddressTempText.contains(searchText))
        })
        //print(resultAddress)
        StationTable.reloadData()
    }
    /* Setup Station Table values */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 12
        if(shouldShowResult == true){
            return resultAddress.count
        }
        else{
            return Stations.keys.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = StationTable.dequeueReusableCell(withIdentifier: "reuseCell")
        cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "reuseCell")
        if(shouldShowResult == true){   //searching
            cell?.textLabel?.text = Stations[resultAddress[indexPath.row]]
            cell?.detailTextLabel?.text = resultAddress[indexPath.row]
        }
        else{   // init ot blank
            cell?.textLabel?.text = StationNameArr[indexPath.row]
            cell?.detailTextLabel?.text = StationAddressArr[indexPath.row]
        }
        return cell!
    }
    /* Developing*/
    
    /* Selected and jumped back(ongoing)*/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Clicked ",indexPath.row)

        /*
        let MainStoryBoard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainStoryBoard")
        self.navigationController?.pushViewController(MainStoryBoard, animated: true)*/
        
        StationTable.deselectRow(at: indexPath, animated: true)
        //self.performSegue(withIdentifier: "BackSegue",sender: self)
    }
    
    
    
    
}
