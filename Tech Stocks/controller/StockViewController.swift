//
//  StockViewController.swift
//  Tech Stocks
//
//  Created by Toluwani Ogunsanya on 2020-07-07.
//  Copyright © 2020 Toluwani Ogunsanya. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import Charts

class StockViewController: UIViewController {

    @IBOutlet var graphHost: LineChartView!
    @IBOutlet var companyImage: UIImageView!
    @IBOutlet var companyName: UILabel!
    @IBOutlet var companyPrice: UILabel!
    let numberFormatter = NumberFormatter()
    var stock: CompanyStock!
    let service = FinnService()

    override func viewDidLoad() {
        super.viewDidLoad()
        numberFormatter.numberStyle = .currency
        loadHeader()
        service.getStockPriceHistory(ticker: stock.company.ticker) { candle, err in
            guard let candle = candle else {
                return
            }
            self.updateGraph(candle: candle)
        }

    }

    @IBAction func viewNewsPressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NewsListController") as! NewsListController
        vc.stock = stock
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func loadHeader() {
        companyName.text = stock.company.name
        guard let formattedNumber = StockCell.numberFormatter.string(from: NSNumber(value: stock.price.close)) else {
            companyPrice.text = "$\(stock.price.close)"
            return
        }
        companyPrice.text = formattedNumber
        let url = URL(string: stock.company.logo)
        print(stock.company.logo)
        companyImage.kf.setImage(with: url)
    }

    private func updateGraph(candle: Candle){
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.



        //here is the for loop
        for i in 0..<candle.close.count {

            let value = ChartDataEntry(x: Double(i+1), y: candle.close[i]) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }

        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Price") //Here we convert lineChartEntry to a LineChartDataSet
        line1.drawCirclesEnabled = false
        line1.colors = [NSUIColor.blue] //Sets the colour to blue


        let data = LineChartData() //This is the object that will be added to the chart

        data.addDataSet(line1) //Adds the line to the dataSet

        self.graphHost.data = data //finally - it adds the chart data to the chart and causes an update
        self.graphHost.chartDescription?.text = "\(stock.company.name) stock for the past year" // Here we set the description for the graph

    }
}
