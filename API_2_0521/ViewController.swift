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

class ViewController: UIViewController {
    
    @IBOutlet var StartingPoint: UITextField!
    @IBOutlet var Destination: UITextField!
    @IBOutlet var mapView: MKMapView!
    
    var StationNameArr = ["南港","台北","板橋","桃園","新竹","苗栗","台中","彰化","雲林","嘉義","台南","左營"]
    var StationAddressArr = ["台北市南港區南港路一段313號","台北市北平西路3號","新北市板橋區縣民大道二段7號","桃園市中壢區高鐵北路一段6號","新竹縣竹北市高鐵七路6號","苗栗縣後龍鎮高鐵三路268號","台中市烏日區站區二路8號","彰化縣田中鎮站區路二段99號","雲林縣虎尾鎮站前東路301號","嘉義縣太保市高鐵西路168號","台南市歸仁區歸仁大道100號","高雄市左營區高鐵路105號"]
    var StationCoordinateArr = [25.053188323974609,121.60706329345703,25.047670364379883,121.51698303222656,25.013870239257813,121.46459197998047,25.012861251831055,121.21472930908203,24.808441162109375,121.04026031494141,24.605447769165039,120.82527160644531,24.112483978271484,120.615966796875,23.874326705932617,120.57460784912109,23.736230850219727,120.41651153564453,23.459506988525391,120.32325744628906,22.925077438354492,120.28620147705078,22.68739128112793,120.30748748779297]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let longPress = UILongPressGestureRecognizer(target: self, action: "MarksClicked")
        longPress.minimumPressDuration = 0.5
        longPress.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(longPress)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AllStationsAnnotation()
        mapView.delegate = self as? MKMapViewDelegate
        
        //_ = UILongPressGestureRecognizer(target: self, action: Selector(("MarksClicked:")))
      
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
    /* Station marks */
    func AllStationsAnnotation(){
        var count = 0
        for i in stride(from: 0, to: 22, by: 2){
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(StationCoordinateArr[i], StationCoordinateArr[i+1])
            annotation.title = StationNameArr[count]
            annotation.subtitle = StationAddressArr[count]
            count+=1
            mapView.addAnnotation(annotation)
        }
    }
    /* Make sure there are stations before segue */
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
    
    @IBAction func unwindToStation(segue: UIStoryboardSegue){
        if let StationTableController = segue.source as? ViewController{
            if(StartingPoint.text == ""){
                StartingPoint.text = StationTableController.ClickedData
            }
            else if(Destination.text == ""){
                Destination.text =
            }
            else{
                StartingPoint.text =
                Destination.text = ""
            }
        }
    }
    
    
    
    
    /* Marks alert [FAILED] */
    func MarksClicked(sender: UILongPressGestureRecognizer){
        print()
        print("--working--")
        print()
        if(sender.state == UIGestureRecognizer.State.began){
            let alertController = UIAlertController(title: "站名", message: "", preferredStyle: .alert)
            let StartAction = UIAlertAction(title: "設成起點", style: .default)
            let DestAction = UIAlertAction(title: "設成終點", style: .default)
            let RestAction = UIAlertAction(title: "附近餐廳", style: .default)
            let CancelAction = UIAlertAction(title: "取消", style: .cancel)
            alertController.addAction(StartAction)
            alertController.addAction(DestAction)
            alertController.addAction(RestAction)
            alertController.addAction(CancelAction)
            present(alertController, animated: true)
        }
    }
    
     
    
    
}

    


