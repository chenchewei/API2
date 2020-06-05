//
//  StationViewController.swift
//  API_2_0521
//
//  Created by mmslab-mini on 2020/5/28.
//  Copyright © 2020 mmslab-mini. All rights reserved.
//

import UIKit

class StationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = SearchController?.searchBar.text{
            filterContent(for:searchText)
            StationTable.reloadData()
        }
    }
    func filterContent(for searchText: String){
        resultName = StationNameArr.filter({(filterArr) -> Bool in
            let words = filterArr
            let Matched = words.localizedCaseInsensitiveContains(searchText)
            return Matched
        })
    }
    

    @IBOutlet var StationTable: UITableView!
    var SearchController: UISearchController?
    var resultName: [String] = []   //Search station name results
    var resultLocation: [String] = []   //Search station location results
    
    var StationNameArr = ["南港","台北","板橋","桃園","新竹","苗栗","台中","彰化","雲林","嘉義","台南","左營"]
    var StationAddressArr = ["台北市南港區南港路一段313號","台北市北平西路3號","新北市板橋區縣民大道二段7號","桃園市中壢區高鐵北路一段6號","新竹縣竹北市高鐵七路6號","苗栗縣後龍鎮高鐵三路268號","台中市烏日區站區二路8號","彰化縣田中鎮站區路二段99號","雲林縣虎尾鎮站前東路301號","嘉義縣太保市高鐵西路168號","台南市歸仁區歸仁大道100號","高雄市左營區高鐵路105號"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StationTable.register(UITableViewCell.self, forCellReuseIdentifier: "reuseCell")
        SearchController = UISearchController(searchResultsController: nil)
        SearchController?.searchResultsUpdater = self
        SearchController?.searchBar.placeholder = "Type THSR stations or locations"
        
    }
    /* Setup Station Table values */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = StationTable.dequeueReusableCell(withIdentifier: "reuseCell")
        cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "reuseCell")
        let resultN = ((SearchController?.isActive)!) ? resultName[indexPath.row] : StationNameArr[indexPath.row]
        let resultL = ((SearchController?.isActive)!) ? resultLocation[indexPath.row] : StationAddressArr[indexPath.row]
        
        cell?.textLabel?.text = resultN
        cell?.detailTextLabel?.text = resultL
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
    /* Search for stations*/
    func StationQuery(){
        
        
        
        
        
        
    }
    
    
    
}
