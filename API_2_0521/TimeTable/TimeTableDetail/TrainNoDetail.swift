//
//  TrainNoDetail.swift
//  API_2_0521
//
//  Created by mmslab-mini on 2020/6/24.
//  Copyright © 2020 mmslab-mini. All rights reserved.
//

import Foundation
/* THSR TrainNo data structure */
public struct Trains: Codable {
    var StopTimes : [StopTimes]
}
public struct StopTimes : Codable {
    var StationName : StationName?
    var Departure : String
}
public struct StationName : Codable {
    var Zh_tw : String?
    var En : String?
}
