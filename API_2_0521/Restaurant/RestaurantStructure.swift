//
//  RestaurantStructure.swift
//  API_2_0521
//
//  Created by mmslab-mini on 2020/6/22.
//  Copyright © 2020 mmslab-mini. All rights reserved.
//

import Foundation
/* Restaurant API data structure */
public struct results : Codable {
//    var type : Int
    var lat : Double
    var lng : Double
    var rating : Double
    var vicinity : String   // Address
    var photo : String
    var reviewsNumber : Int
    
}
