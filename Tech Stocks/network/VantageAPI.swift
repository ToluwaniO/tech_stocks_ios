//
//  VantageAPI.swift
//  Tech Stocks
//
//  Created by Toluwani Ogunsanya on 2020-07-04.
//  Copyright © 2020 Toluwani Ogunsanya. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class VantageAPI {
    enum Endpoints {
        static let base = "https://www.alphavantage.co/query"
        static let apiKey = "JO3Q1JJXLNH7YRLR"
        
        case day(stock: String)
        case week(stock: String)
        case month(stock: String)
        
        var stringValue: String {
            switch self {
                case .day(let stock):
                    return "\(Endpoints.base)?function=TIME_SERIES_DAILY&symbol=\(stock)&apikey=\(Endpoints.apiKey)"
                case .week(let stock):
                    return "\(Endpoints.base)?function=TIME_SERIES_WEEKLY&symbol=\(stock)&apikey=\(Endpoints.apiKey)"
                case .month(let stock):
                    return "\(Endpoints.base)?function=TIME_SERIES_MONTHLY&symbol=\(stock)&apikey=\(Endpoints.apiKey)"
            }
        }
    }
    
    class func getPricesForTheDay(stock: String, completion: @escaping ([Price], Error?) -> Void) {
        let url = Endpoints.day(stock: stock).stringValue
        handleRequest(url: url, parseKey: "Time Series (Daily)", completion: completion)
    }
    
    class func getPricesForTheWeek(stock: String, completion: @escaping ([Price], Error?) -> Void) {
        let url = Endpoints.week(stock: stock).stringValue
        handleRequest(url: url, parseKey: "Weekly Time Series", completion: completion)
    }
    
    class func getPricesForTheMonth(stock: String, completion: @escaping ([Price], Error?) -> Void) {
        let url = Endpoints.month(stock: stock).stringValue
        handleRequest(url: url, parseKey: "Monthly Time Series", completion: completion)
    }
    
    private class func handleRequest(url: String, parseKey: String, completion: @escaping ([Price], Error?) -> Void) {
        print(url)
        AF.request(url).responseJSON() { response in
            switch response.result {
                case .success(let data):
                    let prices = self.parseResponse(data: data, parseKey: parseKey)
                    completion(prices, nil)
                    break
                case .failure(let error):
                    completion([], error)
                    break
            }
        }
    }
    
    private class func parseResponse(data: Any, parseKey: String) -> [Price] {
        let resp = JSON(data)
        let priceTimes = resp[parseKey]
        var prices: [Price] = []
        for (_, val) in priceTimes {
            let price = Price(data: val)
            prices.append(price)
        }
        return prices
    }
}
