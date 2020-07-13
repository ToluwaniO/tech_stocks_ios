//
//  VantageService.swift
//  Tech Stocks
//
//  Created by Toluwani Ogunsanya on 2020-07-04.
//  Copyright © 2020 Toluwani Ogunsanya. All rights reserved.
//

import Foundation

class VantageService {
    class func getPricesForTheDay(completion: @escaping (CompanyStock, Error?) -> Void) {
//        for company in Companies.companies {
//            VantageAPI.getPricesForTheDay(stock: company.stockName) { prices, error in
//                guard error == nil && !prices.isEmpty else {
//                    print(error)
//                    return
//                }
//                let result = CompanyStock(company: company, prices: prices)
//                completion(result, nil)
//            }
//        }
    }
    
    class func getPricesForTheWeek(stock: String, completion: @escaping ([Price], Error?) -> Void) {
//        return VantageAPI.getPricesForTheWeek(stock: stock, completion: completion)
    }
    
    class func getPricesForTheMonth(stock: String, completion: @escaping ([Price], Error?) -> Void) {
//        return VantageAPI.getPricesForTheMonth(stock: stock, completion: completion)
    }
}
