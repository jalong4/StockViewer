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
        guard let url = URL(string: "\(Constants.baseUrl)/stocks") else { return };
        let accessToken = Bundle.main.decode(LoginResponse.self, from: "config.json").response.auth.accessToken
        
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
    
    class func getMockPortfolio() -> Portfolio {
        return Bundle.main.decode(Portfolio.self, from: "data.json")
    }
    
}
