//
// Created by Toluwani Ogunsanya on 2020-07-06.
// Copyright (c) 2020 Toluwani Ogunsanya. All rights reserved.
//

import Foundation
import CoreData
import Network

class FinnService {
    private var resultsController: NSFetchedResultsController<Company>!
    private var dbResults: [Company] = []
    let monitor = NWPathMonitor()
    private var isConnected: Bool = true


    init() {
        initFetchedResultsController()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.isConnected = true
            } else {
                self.isConnected = false
            }

            print(path.isExpensive)
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }

    func getCompanyNews(ticker: String, completion: @escaping ([News], Error?) -> Void) {
        if !isConnected {
            completion([], ServiceError.networkError)
            return
        }
        let date = Date()
        let time = Int(date.timeIntervalSince1970)
        let fDate = Date(timeIntervalSince1970: TimeInterval(time-2628000))
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"

        FinnAPI.getCompanyNews(ticker: ticker, from: dateFormatterGet.string(from: fDate), to: dateFormatterGet.string(from: date)) { news, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    completion([], error)
                    print(error)
                    return
                }
                print(news)
                completion(news ?? [], nil)
            }
        }
    }

    func getCompanyStocks(completion: @escaping ([CompanyStock], Error?) -> Void) {
        if !isConnected {
            completion([], ServiceError.networkError)
            return
        }
        loadCompanies() { companies, error in
            print(companies)
            if error != nil {
                completion([], error)
                return
            }
            self.loadCompanyStock(companies: companies, completion: completion)
        }
    }

    func getStockPriceHistory(ticker: String, completion: @escaping (Candle?, Error?) -> Void) {
        if !isConnected {
            completion(nil, ServiceError.networkError)
            return
        }
        let time = Int(Date().timeIntervalSince1970)
        let begin = time-31536000
        FinnAPI.getCompanyCandle(ticker: ticker, from: String(begin), to: String(time)) { candle, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    completion(nil, ServiceError.other)
                    return
                }
                completion(candle, nil)
            }
        }
    }

    private func loadCompanies(completion: @escaping ([ModelCompany], Error?) -> Void) {
        if !dbResults.isEmpty {
            completion(dbResults.map() { company in ModelCompany.fromDbCompany(company: company) }, nil)
            return
        }
        var cps: [ModelCompany] = []
        var i = 0
        for c in Companies.companies {
            FinnAPI.getCompanyProfile(ticker: c) { (company: ModelCompany?, error: Error?) in
                i+=1
                guard error == nil && company != nil else {
                    print(error)
                    if i == Companies.companies.count {
                        DataController.shared.save()
                        completion(cps, nil)
                    }
                    return
                }
                company?.toDbCompany()
                cps.append(company!)
                if i == Companies.companies.count {
                    DataController.shared.save()
                    completion(cps, nil)
                }
            }
        }
    }

    private func loadCompanyStock(companies: [ModelCompany], completion: @escaping ([CompanyStock], Error?) -> Void) {
        var result: [CompanyStock] = []
        var i = 0
        for company in companies {
            FinnAPI.getCompanyPrice(ticker: company.ticker) { price, error in
                i+=1
                guard error == nil else {
                    print(error)
                    if i == companies.count {
                        completion(result, nil)
                    }
                    return
                }
                result.append(CompanyStock(company: company, price: price!))
                if i == companies.count {
                    completion(result, nil)
                }
            }
        }
    }

    private func initFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Company> = Company.fetchRequest()
        fetchRequest.sortDescriptors = []
        resultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: "companies")
        do {
            try resultsController.performFetch()
            dbResults = resultsController.fetchedObjects ?? []
        } catch {
            print("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
}

enum ServiceError: Error {
    case networkError
    case other
}

extension ServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .networkError:
            return NSLocalizedString("No network connection", comment: "Check your internet connection")
        case .other:
            return NSLocalizedString("An error occurred, it might be your network.", comment: "An error occurred")
        }
    }
}