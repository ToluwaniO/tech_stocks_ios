//
//  FinnAPI.swift
//  Tech Stocks
//
//  Created by Toluwani Ogunsanya on 2020-07-06.
//  Copyright © 2020 Toluwani Ogunsanya. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class FinnAPI {
    enum Endpoints {
        static let base = "https://finnhub.io/api/v1"
        static let token = "bs0l6v7rh5r8uh46fm40"
        
        case companyProfile(ticker: String)
        case companyNews(ticker: String, from: String, to: String)
        case companyPrice(ticker: String)
        case companyCandle(ticker: String, from: String, to: String)
        
        var stringValue: String {
            switch self {
                case .companyProfile(let stock):
                    return "\(Endpoints.base)/stock/profile2?symbol=\(stock)&token=\(Endpoints.token)"
                case .companyNews(let ticker, let from, let to):
                    return "\(Endpoints.base)/company-news?symbol=\(ticker)&from=\(from)&to=\(to)&token=\(Endpoints.token)"
                case .companyPrice(let ticker):
                    return "\(Endpoints.base)/quote?symbol=\(ticker)&token=\(Endpoints.token)"
                case .companyCandle(let ticker, let from, let to):
                    return "\(Endpoints.base)/stock/candle?symbol=\(ticker)&resolution=D&resolution=15&from=\(from)&to=\(to)&token=\(Endpoints.token)"
            }
        }
    }


    class func getCompanyProfile(ticker: String, completion: @escaping (ModelCompany?, Error?) -> Void) {
        handleRequest(url: Endpoints.companyProfile(ticker: ticker).stringValue, responseType: ModelCompany.self, completion: completion)
    }

    class func getCompanyPrice(ticker: String, completion: @escaping (Price?, Error?) -> Void) {
        handleRequest(url: Endpoints.companyPrice(ticker: ticker).stringValue, responseType: Price.self, completion: completion)
    }

    class func getCompanyNews(ticker: String, from: String, to: String, completion: @escaping ([News]?, Error?) -> Void) {
        handleRequest(url: Endpoints.companyNews(ticker: ticker, from: from, to: to).stringValue, responseType: [News].self, completion: completion)
    }

    class func getCompanyCandle(ticker: String, from: String, to: String, completion: @escaping (Candle?, Error?) -> Void) {
        handleRequest(url: Endpoints.companyCandle(ticker: ticker, from: from, to: to).stringValue, responseType: Candle.self, completion: completion)
    }

    private class func handleRequest<ResponseType: Codable>(url: String, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        print(url)
        AF.request(url).responseDecodable(of: responseType.self) { response in
            switch response.result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

struct NewsParams {
    let ticker: String
    let from: String
    let to: String
}

