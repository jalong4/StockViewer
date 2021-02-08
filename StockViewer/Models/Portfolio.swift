//
//  Portfolio.swift
//  StockViewer
//
//  Created by Jim Long on 2/4/21.
//

import SwiftUI
import Combine

struct Portfolio : Codable {
    var summary = Summary();
    var stocks = [Stock]();
}

class PortfolioStore : ObservableObject {
    @Published var portfolio = Portfolio();
}

struct Auth : Codable {
    var accessToken: String
}

class Api {
    func getPortfolio(completion: @escaping (Portfolio) -> ()) {
        guard let url = URL(string: "https://api.jimlong.ca/stocks") else { return };
        let accessToken = Bundle.main.decode(Auth.self, from: "config.json").accessToken
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) {(data, _, _) in
            let portfolio = try! JSONDecoder().decode(Portfolio.self, from: data!)
            DispatchQueue.main.async {
                completion(portfolio)
            }
        }
        .resume()
    }
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    class func getMockPortfolio() -> Portfolio {
        return Bundle.main.decode(Portfolio.self, from: "data.json")
    }
}
