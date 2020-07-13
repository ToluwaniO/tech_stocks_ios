//
//  ModelCompany.swift
//  Tech Stocks
//
//  Created by Toluwani Ogunsanya on 2020-07-04.
//  Copyright © 2020 Toluwani Ogunsanya. All rights reserved.
//

import Foundation

struct ModelCompany: Codable {
    let name: String
    let ticker: String
    let country: String
    let currency: String
    let exchange: String
    let marketCapitalization: Double
    let weburl: String
    let logo: String
    let industry: String

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case ticker = "ticker"
        case logo = "logo"
        case country = "country"
        case currency = "currency"
        case exchange = "exchange"
        case marketCapitalization = "marketCapitalization"
        case weburl = "weburl"
        case industry = "finnhubIndustry"
    }

    func toDbCompany() -> Company {
        let company = Company(context: DataController.shared.viewContext)
        company.ticker = ticker
        company.name = name
        company.logo = logo
        company.country = country
        company.currency = currency
        company.exchange = exchange
        company.marketCapitalization = marketCapitalization
        company.weburl = weburl
        company.industry = industry
        return company
    }

    static func fromDbCompany(company: Company) -> ModelCompany {
        return ModelCompany(name: company.name ?? "", ticker: company.ticker ?? "", country: company.country ?? "",
                currency: company.currency ?? "", exchange: company.exchange ?? "",
                marketCapitalization: company.marketCapitalization ?? 0, weburl: company.weburl ?? "",
                logo: company.logo ?? "", industry: company.industry ?? "")
    }
}
