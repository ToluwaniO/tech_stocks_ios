//
//  StockCell.swift
//  Tech Stocks
//
//  Created by Toluwani Ogunsanya on 2020-07-04.
//  Copyright © 2020 Toluwani Ogunsanya. All rights reserved.
//

import Foundation
import UIKit

class StockCell: UITableViewCell {
    @IBOutlet var stockName: UILabel!
    @IBOutlet var companyName: UILabel!
    @IBOutlet var price: UILabel!
    static let numberFormatter = NumberFormatter()
    
    func configure(company: ModelCompany, price: Double) -> Void {
        StockCell.numberFormatter.numberStyle = .currency
        stockName.text = company.ticker
        companyName.text = company.name
        guard let formattedNumber = StockCell.numberFormatter.string(from: NSNumber(value: price)) else {
            self.price.text = "$\(price)"
            return
        }
        self.price.text = formattedNumber
    }
    
}
