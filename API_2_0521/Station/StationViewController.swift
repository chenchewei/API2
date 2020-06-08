//
//  StationViewController.swift
//  API_2_0521
//
//  Created by mmslab-mini on 2020/5/28.
//  Copyright © 2020 mmslab-mini. All rights reserved.
//

import UIKit

class StationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {//,UISearchResultsUpdating
    
    @IBOutlet var StationTable: UITableView!
    
    var searchController: UISearchController!
    var resultName = [String]()
    /*
    var resultLocation: [String] = [String](){
        didSet {
            self.StationTable.reloadData(∫)
        }
        
    }   //Search station location results*/
    
    var StationNameArr = ["南港","台北","板橋","桃園","新竹","苗栗","台中","彰化","雲林","嘉義","台南","左營"]
    var StationAddressArr = ["台北市南港區南港路一段313號","台北市北平西路3號","新北市板橋區縣民大道二段7號","桃園市中壢區高鐵北路一段6號","新竹縣竹北市高鐵七路6號","苗栗縣後龍鎮高鐵三路268號","台中市烏日區站區二路8號","彰化縣田中鎮站區路二段99號","雲林縣虎尾鎮站前東路301號","嘉義縣太保市高鐵西路168號","台南市歸仁區歸仁大道100號","高雄市左營區高鐵路105號"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StationTable.register(UITableViewCell.self, forCellReuseIdentifier: "reuseCell")
        StationTable.delegate = self
        StationTable.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        searchController = UISearchController(searchResultsController: nil)
        //searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        //searchController.isActive = true
        //print("Pre")
        //print(searchController.isActive)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("search2 working")
        let searchText = searchController.searchBar.text!
        print(searchController.isActive)
        print(searchText)
        resultName = StationNameArr.filter({ (Stations) -> Bool in
            //print(resultName)
            return Stations.contains(searchText)
        })
        print("Done?")
        //StationTable.reloadData()
        
    }
    /*
    func updateSearchResults(for searchController: UISearchController) {
        print("search working")
        let searchText = searchController.searchBar.text!
        resultName = StationNameArr.filter({ (Stations) -> Bool in
            print(resultName)
            return Stations.contains(searchText)
        })
        StationTable.reloadData()
        print("Done")
        
        /*if let searchText = SearchController?.searchBar.text{
            print("searching")
            filterContent(for: searchText)
            StationTable.reloadData()
        }*/
    }
    /*func filterContent(for searchText: String){
        
        resultName = StationNameArr.filter({(filterArr) -> Bool in
            let words = filterArr
            let Matched = words.localizedCaseInsensitiveContains(searchText)
            print("filtering")
            return Matched
            
        })
    }*/
    */
    
    
    /* Setup Station Table values */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(navigationItem.searchController?.isActive == true){
            return resultName.count
        }
        else{
            return StationNameArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = StationTable.dequeueReusableCell(withIdentifier: "reuseCell")
        cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "reuseCell")
        if(navigationItem.searchController?.isActive == true){
            cell?.textLabel?.text = resultName[indexPath.row]
        }
        else{/*
            let resultN = ((searchController?.isActive)!) ? resultName[indexPath.row] : StationNameArr[indexPath.row]
            let resultL = ((searchController?.isActive)!) ? resultLocation[indexPath.row] : StationAddressArr[indexPath.row]*/
            
            cell?.textLabel?.text = StationNameArr[indexPath.row]
            cell?.detailTextLabel?.text = StationAddressArr[indexPath.row]
            //print("not active")
        }
        
        return cell!
    }
    
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
