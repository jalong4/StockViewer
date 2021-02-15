//
//  Api.swift
//  StockViewer
//
//  Created by Jim Long on 2/8/21.
//

import Foundation


class Api {
    
    func login(email: String, password: String, completion: @escaping (LoginResponse) -> ()) {
        guard let url = URL(string: "\(Constants.baseUrl)/users/login") else { return };
        
        let json = [ "email" : email, "password" : password ]
        let body = try! JSONSerialization.data(withJSONObject: json, options: [])
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) {(data, _, _) in
            let response = try! JSONDecoder().decode(LoginResponse.self, from: data!)
            DispatchQueue.main.async {
                completion(response)
            }
        }
        .resume()
    }
    
    func getPortfolio(completion: @escaping (Portfolio) -> ()) {
        guard let url = URL(string: "\(Constants.baseUrl)/stocks"),
              let accessToken = SettingsManager.sharedInstance.accessToken
        else { return };
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                fatalError("Failed to get portfolio data: Error: \(error)")
            }
            
            guard let data = data else {
                fatalError("Failed to get portfolio data")
            }
            
            let portfolio = Utils.decodeToObj(Portfolio.self, from: data)
            
            DispatchQueue.main.async {
                completion(portfolio)
            }
        }
        .resume()
    }
    
    func getHoldingsForAccount(account: String, completion: @escaping (HoldingsResponse) -> ()) {
        guard let url = URL(string: "\(Constants.baseUrl)/holdings/account/\(account)"),
              let accessToken = SettingsManager.sharedInstance.accessToken
        else { return };
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                fatalError("Failed to get holdings data: Error: \(error)")
            }
            
            guard let data = data else {
                fatalError("Failed to get holdings data")
            }
            
            let holdingsResponse = Utils.decodeToObj(HoldingsResponse.self, from: data)
            
            DispatchQueue.main.async {
                completion(holdingsResponse)
            }
        }
        .resume()
    }
    
//    func getStockQuote(ticker: String, completion: @escaping ([String: Any]) -> ()) {
//        guard let url = URL(string: "\(Constants.baseUrl)/stocks/quote/\(ticker)"),
//              let accessToken = SettingsManager.sharedInstance.accessToken
//        else { return };
//
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//
//        URLSession.shared.dataTask(with: request) {(data, response, error) in
//
//            if let error = error {
//                fatalError("Failed to get stock quote data: Error: \(error)")
//            }
//
//            guard let data = data else {
//                fatalError("Failed to get stock quote data")
//            }
//
//            do {
//                if let jsonResult = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
//                        DispatchQueue.main.async {
//                            completion(jsonResult)
//                        }
//                }
//            } catch let parseError {
//                fatalError("JSON Error \(parseError.localizedDescription)")
//            }
//        }
//        .resume()
//    }
    
    func getStockQuote(ticker: String, completion: @escaping (Quote?) -> ()) {
        guard let url = URL(string: "\(Constants.baseUrl)/stocks/quote/\(ticker)"),
              let accessToken = SettingsManager.sharedInstance.accessToken
        else { return };
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                fatalError("Failed to get quote data: Error: \(error)")
            }
            
            guard let data = data else {
                fatalError("Failed to get quote data")
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .deferredToDate
            decoder.keyDecodingStrategy = .useDefaultKeys
            
            var quoteResponse: QuoteResponse? = nil
            do {
                quoteResponse = try decoder.decode(QuoteResponse.self, from: data)
            } catch {
                print("No quote found for ticker: \(ticker)")
            }
            
            DispatchQueue.main.async {
                completion(quoteResponse?.result?.first)
            }
        }
        .resume()
    }
    
    func updateHolding(holding: Holding, completion: @escaping (Holding) -> ()) {
        guard let url = URL(string: "\(Constants.baseUrl)/holdings/\(holding._id)"),
              let accessToken = SettingsManager.sharedInstance.accessToken,
              let body = try? JSONEncoder().encode(HoldingBody(holding: holding))
        else { return };
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                fatalError("Failed to get holdings data: Error: \(error)")
            }
            
            guard let data = data else {
                fatalError("Failed to get holdings data")
            }
            
            let holding = Utils.decodeToObj(Holding.self, from: data)
            
            DispatchQueue.main.async {
                completion(holding)
            }
        }
        .resume()
    }
    
    func createHolding(holdingBody: HoldingBody, completion: @escaping (Holding) -> ()) {
        guard let url = URL(string: "\(Constants.baseUrl)/holdings"),
              let accessToken = SettingsManager.sharedInstance.accessToken,
              let body = try? JSONEncoder().encode(holdingBody)
        else {
            return
        };
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                fatalError("Failed to get holdings data: Error: \(error)")
            }
            
            guard let data = data else {
                fatalError("Failed to get holdings data")
            }
            
            let holding = Utils.decodeToObj(Holding.self, from: data)
            
            DispatchQueue.main.async {
                completion(holding)
            }
        }
        .resume()
    }
    
    func deleteHolding(id: String, completion: @escaping (String) -> ()) {
        guard let url = URL(string: "\(Constants.baseUrl)/holdings/id/\(id)"),
              let accessToken = SettingsManager.sharedInstance.accessToken
        else { return };
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                fatalError("Failed to get holdings data: Error: \(error)")
            }
            
            guard let data = data else {
                fatalError("Failed to get holdings data")
            }
            
            let msg = Utils.decodeToObj([String: String].self, from: data)
            
            DispatchQueue.main.async {
                completion(msg["message"] ?? "")
            }
        }
        .resume()
    }
    
    class func getMockPortfolio() -> Portfolio {
        return Bundle.main.decode(Portfolio.self, from: "data.json")
    }
    
}
