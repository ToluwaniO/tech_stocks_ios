//
// Created by Toluwani Ogunsanya on 2020-07-06.
// Copyright (c) 2020 Toluwani Ogunsanya. All rights reserved.
//

import Foundation
 struct Candle: Codable {
     let open: [Double]
     let close: [Double]
     let low: [Double]
     let high: [Double]
     let volume: [Double]
     let time: [Double]

     enum CodingKeys: String, CodingKey {
         case open = "o"
         case close = "c"
         case low = "l"
         case high = "h"
         case volume = "v"
         case time = "t"
     }
 }