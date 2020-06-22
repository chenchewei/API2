//
//  THSR.swift
//  API_2_0521
//
//  Created by mmslab-mini on 2020/6/22.
//  Copyright © 2020 mmslab-mini. All rights reserved.
//

import Foundation
/* THSR API data structure */
public struct THSRModel : Codable {
    var DailyTrainInfo : DailyTrainInfo?
    var OriginStopTime : OriginStopTime?
    var DestinationStopTime : DestinationStopTime?
}
public struct DailyTrainInfo : Codable {
    var TrainNo : String?
    var Direction : Int?
    var StartingStationName : String
}
public struct OriginStopTime : Codable {
    var ArrivalTime : String?
    var DepartureTime : String?
    var StationName : StationNames
}
public struct DestinationStopTime : Codable {
    var ArrivalTime : String?
    var DepartureTime : String?
    var StationName : StationNames
}
