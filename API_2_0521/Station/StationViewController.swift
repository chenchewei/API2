//
//  StationViewController.swift
//  API_2_0521
//
//  Created by mmslab-mini on 2020/5/28.
//  Copyright © 2020 mmslab-mini. All rights reserved.
//

import UIKit
import MapKit

protocol StationReturnDelegate {
    func sendStationCoordinates(sentData: StationReturnValue)
}

class StationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var StationTable: UITableView!
    /* Search bar settings*/
    var searchController: UISearchController!
    var StationList = [Station]()
    var searchingList = [Station]()
   
    var StationRE : StationReturnValue!
    
    var delegate : StationReturnDelegate?       // cant use weak var
/* Pre load */
    override func viewDidLoad() {
        super.viewDidLoad()
        StationTable.register(UITableViewCell.self, forCellReuseIdentifier: "reuseCell")
        StationTable.delegate = self
        StationTable.dataSource = self
        searchingList = StationList
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
            searchingList = StationList
        }
        else{
            searchingList = StationList.filter({ (station) -> Bool in
                return (station.StationAddress.contains(searchText) || station.StationName.contains(searchText))
            })
        }
        StationTable.reloadData()
    }
    /* Setup Station Table values */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchingList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = StationTable.dequeueReusableCell(withIdentifier: "reuseCell")
        cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "reuseCell")
        cell?.textLabel?.text = StationList[indexPath.row].StationName
        cell?.detailTextLabel?.text = StationList[indexPath.row].StationAddress
        return cell!
    }
    /* Selected and jumped back(ongoing)*/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Clicked ",indexPath.row)
        StationTable.deselectRow(at: indexPath, animated: true)
        /* Error*/
        StationRE.ReturnLat = searchingList[indexPath.row].StationPositionLat
        StationRE.ReturnLon = searchingList[indexPath.row].StationPositionLon
        StationRE.ReturnFlag = true
        
        delegate?.sendStationCoordinates(sentData: StationRE)

        navigationController?.popViewController(animated: true)

        


        

    }
    
    
    
    
}
