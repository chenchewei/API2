//
//  PTX.swift
//  API_2_0521
//
//  Created by mmslab-mini on 2020/6/18.
//  Copyright © 2020 mmslab-mini. All rights reserved.
//

import Foundation

/* PTX API data structure */
public struct PTX : Codable {
    var StationID : String
    var StationAddress : String
    var StationName : StationNames?
    var StationPosition : StationPositions?
}
public struct StationNames : Codable {
    var Zh_tw : String?
    var En : String?
}
public struct StationPositions : Codable {
    var PositionLat : Double?
    var PositionLon : Double?
}
