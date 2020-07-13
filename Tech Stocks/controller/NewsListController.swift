//
// Created by Toluwani Ogunsanya on 2020-07-07.
// Copyright (c) 2020 Toluwani Ogunsanya. All rights reserved.
//

import Foundation
import UIKit

class NewsListController: UITableViewController {
    var newsList: [News]! = []
    var stock: CompanyStock!
    let service = FinnService()
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var stateText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        service.getCompanyNews(ticker: stock.company.ticker) { news, err in
            self.spinner.stopAnimating()
            guard err == nil else {
                self.stateText.text = err?.localizedDescription
                return
            }
            if news.isEmpty {
                self.stateText.text = ServiceError.other.localizedDescription
                return
            }
            self.stateText.isHidden = true
            guard err == nil else {
                return
            }
            self.newsList = news
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
        let news = newsList[indexPath.row]
        cell.configure(news: news)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        super.tableView(tableView, didSelectRowAt: indexPath)
        let news = newsList[indexPath.row]
        if let url = URL(string: news.url) {
            UIApplication.shared.open(url)
        }
    }


}
