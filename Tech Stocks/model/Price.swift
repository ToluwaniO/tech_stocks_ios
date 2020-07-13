//
//  Price.swift
//  Tech Stocks
//
//  Created by Toluwani Ogunsanya on 2020-07-04.
//  Copyright © 2020 Toluwani Ogunsanya. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Price: Codable {
    let open: Double
    let close: Double
    let low: Double
    let high: Double
    let volume: Double?
    
    init(data: JSON) {
        open = Double(data["1. open"].string ?? "") ?? 0
        close = Double(data["4. close"].string ?? "") ?? 0
        low = Double(data["3. low"].string ?? "") ?? 0
        high = Double(data["2. high"].string ?? "") ?? 0
        volume = Double(data["5. volume"].string ?? "") ?? 0
    }

    enum CodingKeys: String, CodingKey {
        case open = "o"
        case close = "c"
        case low = "l"
        case high = "h"
        case volume = "v"
    }
}
