//
//  ViewController.swift
//  Tech Stocks
//
//  Created by Toluwani Ogunsanya on 2020-07-04.
//  Copyright © 2020 Toluwani Ogunsanya. All rights reserved.
//

import UIKit

class StockListController: UITableViewController {
    var stocks: [CompanyStock]! = []
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var stateText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        FinnAPI.getCompanyProfile(ticker: "LYFT") { company, error in
//            print(company)
//        }

        loadStock()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell") as! StockCell
        let stock = stocks[indexPath.row]
        let price = stock.price
        cell.configure(company: stock.company, price: price.close)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        super.tableView(tableView, didSelectRowAt: indexPath)
        print("selected")
        let stockVC = storyboard?.instantiateViewController(withIdentifier: "StockViewController") as! StockViewController
        stockVC.stock = stocks[indexPath.row]
        navigationController?.pushViewController(stockVC, animated: true)
    }

    private func loadStock() {
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        FinnService().getCompanyStocks() { stocks, err in
            self.spinner.stopAnimating()
            guard err == nil else {
                self.stateText.text = err?.localizedDescription
                return
            }
            if stocks.isEmpty {
                self.stateText.text = ServiceError.other.localizedDescription
                return
            }
            self.stateText.isHidden = true
            self.stocks = stocks
            self.tableView.reloadData()
        }
    }


}

