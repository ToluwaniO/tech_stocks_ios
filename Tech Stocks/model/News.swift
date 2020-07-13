//
// Created by Toluwani Ogunsanya on 2020-07-06.
// Copyright (c) 2020 Toluwani Ogunsanya. All rights reserved.
//

import Foundation


struct News: Codable {
    let url: String
    let summary: String
    let source: String
    let image: String
    let headline: String
    let datetime: Int
}