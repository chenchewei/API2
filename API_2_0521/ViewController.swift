//
//  ViewController.swift
//  API_2_0521
//
//  Created by mmslab-mini on 2020/5/21.
//  Copyright © 2020 mmslab-mini. All rights reserved.
//

import UIKit
import MapKit
import Toast
import Foundation
import CommonCrypto

/********************** PTX Auth key from sample code ******************************/
enum CryptoAlgorithm {  // 列舉
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    var HMACAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:      result = kCCHmacAlgMD5
        case .SHA1:     result = kCCHmacAlgSHA1
        case .SHA224:   result = kCCHmacAlgSHA224
        case .SHA256:   result = kCCHmacAlgSHA256
        case .SHA384:   result = kCCHmacAlgSHA384
        case .SHA512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}
extension String {
    func hmac(algorithm: CryptoAlgorithm, key: String) -> String {
        let cKey = key.cString(using: String.Encoding.utf8)
        let cData = self.cString(using: String.Encoding.utf8)
        let digestLen = algorithm.digestLength
        var result = [CUnsignedChar](repeating: 0, count: digestLen)
        CCHmac(algorithm.HMACAlgorithm, cKey!, strlen(cKey!), cData!, strlen(cData!), &result)
        let hmacData:Data = Data(bytes: result, count: digestLen)
        let hmacBase64 = hmacData.base64EncodedString(options: .lineLength64Characters)
        return String(hmacBase64)
    }
}
func getServerTime() -> String {
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "EEE, dd MMM yyyy HH:mm:ww zzz"
    dateFormater.locale = Locale(identifier: "en_US")
    dateFormater.timeZone = TimeZone(secondsFromGMT: 0)
    return dateFormater.string(from: Date())
}
let APIUrl = "https://ptx.transportdata.tw/MOTC/v2/Rail/THSR/Station?$top=30&$format=JSON";
let APP_ID = "FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF"
let APP_KEY = "FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF"
let xdate : String = getServerTime();
let signDate = "x-date: " + xdate;
let base64HmacStr = signDate.hmac(algorithm: .SHA1, key: APP_KEY)
let authorization:String = "hmac username=\""+APP_ID+"\", algorithm=\"hmac-sha1\", headers=\"x-date\", signature=\""+base64HmacStr+"\""
/*******************************************************************************/
/* API datas */
public class Station {
    var StationName = ""
    var StationAddress = ""
    var StationID = ""
    var StationPositionLat = Double()
    var StationPositionLon = Double()
}
/* Return coodinates from StationViewController */
public class StationReturnValue {
    var ReturnLat = Double()
    var ReturnLon = Double()
    var ReturnFlag = false
}

class ViewController: UIViewController {
    
    @IBOutlet var StartingPoint: UITextField!
    @IBOutlet var Destination: UITextField!
    @IBOutlet var mapView: MKMapView!
    
    var StationData = [PTX]()
    var SearchList = [Station]()
    var StationRE : StationReturnValue!    // return values
    
    var TimeTableStartID = ""
    var TimeTableDesID = ""
    
//    var startStation:PTX? = nil
//    var endStation:PTX? = nil
    
    /* THSR */
    var THSRdata = [THSRModel]()
    var TimeTableList = [THSRDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromAPI()
        mapViewInit()
        StationRE = StationReturnValue()
        /* Prevent users from misclicking */
        StartingPoint.isUserInteractionEnabled = false
        Destination.isUserInteractionEnabled = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        ReturnValueActions()    // Actions after poplast from StationVC
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let StationVC = segue.destination as! StationViewController
        StationVC.StationRE = StationRE
        StationVC.delegate = self
    }

    func mapViewInit() {
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "annView")
    }
    
    /* Environments set up */
    func getDataFromAPI() {
        let url = URL(string: APIUrl)
        var request = URLRequest(url: url!)
        request.setValue(xdate, forHTTPHeaderField: "x-date")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        let task = URLSession.shared.dataTask(with: request){ data, response,error in
        do {
            var StationList = [Station]()
            self.StationData = try JSONDecoder().decode([PTX].self, from: data!)
                        
            for i in 0..<self.StationData.count {
                let station = Station()
                station.StationID = self.StationData[i].StationID
                station.StationName = self.StationData[i].StationName?.Zh_tw ?? ""
                station.StationAddress = self.StationData[i].StationAddress
                station.StationPositionLat = self.StationData[i].StationPosition?.PositionLat ?? 0.0
                station.StationPositionLon = self.StationData[i].StationPosition?.PositionLon ?? 0.0
                StationList.append(station)
                self.SearchList = StationList   //throw datas
                /* Station pins */
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2DMake(StationList[i].StationPositionLat, StationList[i].StationPositionLon)
                annotation.title = StationList[i].StationName
                annotation.subtitle = StationList[i].StationID  // StationAddress
                
                DispatchQueue.main.async {
                    self.mapView.addAnnotation(annotation)
                }
                
            }
        }
        catch {
            print(error.localizedDescription)
            }
        }
        task.resume()
    }
    /* Show current location */
    static var location:CLLocationManager? = nil
    @IBAction func CurrentLocation(_ sender: Any) {
        if(ViewController.location == nil){
            ViewController.location = CLLocationManager()
            ViewController.location?.requestWhenInUseAuthorization()
            ViewController.location?.startUpdatingLocation()
        }
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
   /* Switch Text */
    @IBAction func switchText(_ sender: Any) {
        if(StartingPoint.text != Destination.text){
            let temp = StartingPoint.text
            StartingPoint.text = Destination.text
            Destination.text = temp
        }
        else{
            if(StartingPoint.text == Destination.text){
                if(StartingPoint.text == "") {
                    view.makeToast("Starting point and destination cannot be blank.")
                }
            }
        }
    }
    
    /* Making sure station texts aren't empty before pushVC and jump after datas received */
    @IBAction func TimeTableBtnClicked(_ sender: Any) {
        if(StartingPoint.text == Destination.text){
            if(StartingPoint.text == "") {
                view.makeToast("請輸入起終點")
            }
            else {
                view.makeToast("起終點應不同")
            }
        }
        else if(StartingPoint.text == ""){
            view.makeToast("請輸入起點")
        } else if(Destination.text == "") {
            view.makeToast("請輸入終點")
        }
        else{
            DispatchQueue.main.async {
                self.getTHSRDatas()
            }
        }
    }
    /* Request THSR API datas */
    func getTHSRDatas() {
        let TodayDate : String = getFormattedTime();
        let TimeTableURL = "https://ptx.transportdata.tw/MOTC/v2/Rail/THSR/DailyTimetable/OD/"+TimeTableStartID+"/to/"+TimeTableDesID+"/"+TodayDate+"?$top=30&$format=JSON"
        let url = URL(string: TimeTableURL)
        var request = URLRequest(url: url!)
        request.setValue(xdate, forHTTPHeaderField: "x-date")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        URLSession.shared.dataTask(with: request){ data, response,error in do {
            var TempList = [THSRDetail]()
            self.THSRdata = try JSONDecoder().decode([THSRModel].self, from: data!)
            for i in 0..<self.THSRdata.count {
                let timeTable = THSRDetail()
                if(self.THSRdata[i].DailyTrainInfo?.Direction == 0) {
                    timeTable.Direction = "南下"
                }
                else{
                    timeTable.Direction = "北上"
                }
                timeTable.TrainNo = self.THSRdata[i].DailyTrainInfo?.TrainNo ?? ""
                timeTable.DepartureTime = self.THSRdata[i].OriginStopTime?.ArrivalTime ?? ""
                timeTable.ArrivalTime = self.THSRdata[i].DestinationStopTime?.ArrivalTime ?? ""
                TempList.append(timeTable)
                self.TimeTableList = TempList
            }
            /* Jump to TimeTableVC */
            DispatchQueue.main.async {
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let TimeTableVC = storyboard.instantiateViewController(withIdentifier:"Timetable") as! TimeTableViewController
                
                TimeTableVC.StartName = self.StartingPoint.text ?? ""
                TimeTableVC.DesName = self.Destination.text ?? ""
                TimeTableVC.xdate = xdate
                TimeTableVC.authorization = authorization
                TimeTableVC.TimeTableList = self.TimeTableList
                self.navigationController?.pushViewController(TimeTableVC, animated: true)
            }
        }
        catch {
            print(error.localizedDescription)
            }
        }.resume()
        
    }
    func getFormattedTime() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        return dateFormater.string(from: Date())
    }
    /* Jump to StationViewController */
    @IBAction func StationClicked(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let StationVC = storyboard.instantiateViewController(withIdentifier:"Station") as! StationViewController
        StationVC.StationList = SearchList
        StationVC.delegate = self
        self.navigationController?.pushViewController(StationVC, animated: true)
    }
    /* Return the chosen station and set mapview region */
    func ReturnValueActions() {
        if(StationRE.ReturnFlag){
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let center = CLLocationCoordinate2D(latitude: StationRE.ReturnLat, longitude: StationRE.ReturnLon)
            let region = MKCoordinateRegion(center: center , span: span)
            mapView.setRegion(region, animated:true)
            StationRE.ReturnFlag = false
        }
    }
}

extension ViewController: StationReturnDelegate {
    func sendStationCoordinates(sentData: StationReturnValue){
        StationRE = sentData
    }
}

extension ViewController:  MKMapViewDelegate{
      
        
    
    /* Tap and show alert view */
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        
                
        if view.annotation?.isKind(of:MKUserLocation.self) ?? true {
            return
        }
        
        
        let ann = view.annotation?.title
        let SelectedID = view.annotation?.subtitle
        
        let alertController = UIAlertController(title: "選擇動作", message: "", preferredStyle: .alert)
        let StartAction = UIAlertAction(title: "設成起點", style: .default,handler:{ (action) in
            self.StartingPoint.text = ann!!
            self.StartingPoint.isUserInteractionEnabled = true
            self.TimeTableStartID = SelectedID!!})
        let DestAction = UIAlertAction(title: "設成終點", style: .default,handler:{ (action) in
            self.Destination.text = ann!!
            self.Destination.isUserInteractionEnabled = true
            self.TimeTableDesID = SelectedID!!
        })
        let RestAction = UIAlertAction(title: "附近餐廳", style: .default,handler:{ (action)in
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let RestaurantVC = storyboard.instantiateViewController(withIdentifier:"Restaurant") as! RestaurantViewController
            RestaurantVC.PinLat = view.annotation?.coordinate.latitude ?? 0.0
            RestaurantVC.PinLng = view.annotation?.coordinate.longitude ?? 0.0
            self.navigationController?.pushViewController(RestaurantVC, animated: true
        )})
        let CancelAction = UIAlertAction(title: "取消", style: .cancel)
        alertController.addAction(StartAction)
        alertController.addAction(DestAction)
        alertController.addAction(RestAction)
        alertController.addAction(CancelAction)
        present(alertController, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
                
        if annotation.isKind(of:MKUserLocation.self) {
            return nil
        }
        
        let annView = mapView.dequeueReusableAnnotationView(withIdentifier: "annView", for: annotation) as! MKMarkerAnnotationView
        annView.clusteringIdentifier = nil
        annView.displayPriority = .required
        return annView
    }
}
