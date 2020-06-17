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


/* PTX Auth key from sample code */
enum CryptoAlgorithm {
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

/* API data structure */
public class PTX : Codable {
    var StationID : String
    var StationAddress : String
    var StationName : StationNames?
    var StationPosition : StationPositions?
}
public class StationNames : Codable {
    var Zh_tw : String?
    var En : String?
}
public class StationPositions : Codable {
    var PositionLat : Double?
    var PositionLon : Double?
}
/* API datas*/
public class Station {
    var StationName = ""
    var StationAddress = ""
    var StationID = ""
    var StationPositionLat = Double()
    var StationPositionLon = Double()
}

class ViewController: UIViewController,MKMapViewDelegate {
    
    @IBOutlet var StartingPoint: UITextField!
    @IBOutlet var Destination: UITextField!
    @IBOutlet var mapView: MKMapView!
    var StationList = [Station]()
    var StationData = [PTX]()

    func getDataFromAPI(){
        let url = URL(string: APIUrl)
        var request = URLRequest(url: url!)
        request.setValue(xdate, forHTTPHeaderField: "x-date")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        
        URLSession.shared.dataTask(with: request){ data, response,error in
            do{
//                print(response)
//                print()
                let StationData = try JSONDecoder().decode([PTX].self, from: data!)
                print(StationData)
                self.StationData = StationData
                for i in 0..<StationData.count{
                    let station = Station()
                    station.StationName = StationData.
                }
            }
            catch{
                print(error)
            }
        }.resume()
    }
    
    
    /*
    var StationNameArr = ["南港","台北","板橋","桃園","新竹","苗栗","台中","彰化","雲林","嘉義","台南","左營"]
    var StationAddressArr = ["台北市南港區南港路一段313號","台北市北平西路3號","新北市板橋區縣民大道二段7號","桃園市中壢區高鐵北路一段6號","新竹縣竹北市高鐵七路6號","苗栗縣後龍鎮高鐵三路268號","台中市烏日區站區二路8號","彰化縣田中鎮站區路二段99號","雲林縣虎尾鎮站前東路301號","嘉義縣太保市高鐵西路168號","台南市歸仁區歸仁大道100號","高雄市左營區高鐵路105號"]
    var StationCoordinateArr = [25.053188323974609,121.60706329345703,25.047670364379883,121.51698303222656,25.013870239257813,121.46459197998047,25.012861251831055,121.21472930908203,24.808441162109375,121.04026031494141,24.605447769165039,120.82527160644531,24.112483978271484,120.615966796875,23.874326705932617,120.57460784912109,23.736230850219727,120.41651153564453,23.459506988525391,120.32325744628906,22.925077438354492,120.28620147705078,22.68739128112793,120.30748748779297]*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        getDataFromAPI()
        
    }
/*
    override func viewWillAppear(_ animated: Bool) {
        AllStationsAnnotation()
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
            view.makeToast("Starting point and destination should be different.")
        }
    }
    /* Station pins */
    func AllStationsAnnotation(){
        var count = 0
        for i in stride(from: 0, to: 24, by: 2){
            let annotation = MKPointAnnotation()
            print(annotation)
            annotation.coordinate = CLLocationCoordinate2DMake(StationCoordinateArr[i], StationCoordinateArr[i+1])
            annotation.title = StationNameArr[count]
            annotation.subtitle = StationAddressArr[count]
            //print(count)
            count+=1
            mapView.addAnnotation(annotation)
        }
    }
    /* Tap and show alert view */
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        let alertController = UIAlertController(title: "選擇動作", message: "", preferredStyle: .alert)
        let StartAction = UIAlertAction(title: "設成起點", style: .default,handler:{ (action) in /*self.StartingPoint.text = self.StationNameArr[count]*/})
        let DestAction = UIAlertAction(title: "設成終點", style: .default)
        let RestAction = UIAlertAction(title: "附近餐廳", style: .default)
        let CancelAction = UIAlertAction(title: "取消", style: .cancel)
        alertController.addAction(StartAction)
        alertController.addAction(DestAction)
        alertController.addAction(RestAction)
        alertController.addAction(CancelAction)
        present(alertController, animated: true)
    }
    /* Making sure station texts arent blank before segue */
    @IBAction func CheckText(_ sender: Any) {
        if(StartingPoint.text == Destination.text){
            view.makeToast("Starting point and destination should be different.")
        }
        else if(StartingPoint.text == "" || Destination.text == ""){
            view.makeToast("Starting point and destination cannot be blank.")
        }
        else{
            self.performSegue(withIdentifier: "TimeTableSegue",sender: self)
        }
    }
    /* Segue back from StationViewController[unwind FAILED] */

    */
}



