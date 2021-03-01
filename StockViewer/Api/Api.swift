//
//  Api.swift
//  StockViewer
//
//  Created by Jim Long on 2/8/21.
//

import UIKit


class Api {
    
    func login(email: String, password: String, completion: @escaping (LoginResponse) -> ()) {
        guard let url = URL(string: "\(Constants.baseUrl)/users/login")
        else {
            return
        };
        
        let json = [ "email" : email, "password" : password ]
        let body = try! JSONSerialization.data(withJSONObject: json, options: [])
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                fatalError("Failed to login: Error: \(error)")
            }
            
            guard let data = data else {
                fatalError("Failed to get login data")
            }
            
            let response = Utils.decodeToObj(LoginResponse.self, from: data)
            DispatchQueue.main.async {
                completion(response)
            }
        }
        .resume()
    }
    
    func registerUser(user: [String: String], completion: @escaping (RegistrationResponse) -> ()) {
        guard let url = URL(string: "\(Constants.baseUrl)/users/register")
        else {
            return
        };
        
        let body = try! JSONSerialization.data(withJSONObject: user, options: [])
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                fatalError("Failed to register user: Error: \(error)")
            }
            
            guard let data = data else {
                fatalError("Failed to get registration data")
            }
            
            let response = Utils.decodeToObj(RegistrationResponse.self, from: data)
            DispatchQueue.main.async {
                completion(response)
            }
        }
        .resume()
    }
    
    func changePassword(oldPassword: String, newPassword: String, completion: @escaping (ChangePasswordResponse) -> ()) {
        guard
            let url = URL(string: "\(Constants.baseUrl)/users/password"),
            let accessToken = SettingsManager.sharedInstance.accessToken
        else {
            return
        };
        
        let json = [ "oldPassword" : oldPassword, "newPassword" : newPassword ]
        let body = try! JSONSerialization.data(withJSONObject: json, options: [])
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                fatalError("Failed to change password: Error: \(error)")
            }
            
            guard let data = data else {
                fatalError("Failed to get change password data")
            }
            
            let response = Utils.decodeToObj(ChangePasswordResponse.self, from: data)
            DispatchQueue.main.async {
                completion(response)
            }
        }
        .resume()
    }
    
    func getPortfolio(completion: @escaping (Portfolio) -> ()) {
        guard let url = URL(string: "\(Constants.baseUrl)/stocks"),
              let accessToken = SettingsManager.sharedInstance.accessToken
        else {
            print(SettingsManager.sharedInstance.accessToken ?? "Nil access Token")
            SettingsManager.sharedInstance.isLoggedIn = false
            return
        };
        
        
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
        guard
            let accountEncoded = account.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: "\(Constants.baseUrl)/holdings/account/\(accountEncoded)"),
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
    
    func getUser(completion: @escaping (User?) -> ()) {
        
        guard
            let userId = Utils.getUserIdFromToken(),
            let url = URL(string: "\(Constants.baseUrl)/users/id/\(userId)"),
            let accessToken = SettingsManager.sharedInstance.accessToken
        else { return };
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                fatalError("Failed to get user data: Error: \(error)")
            }
            
            guard let data = data else {
                fatalError("Failed to get user data")
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .deferredToDate
            decoder.keyDecodingStrategy = .useDefaultKeys
            
            var user: User? = nil
            do {
                user = try decoder.decode(User.self, from: data)
            } catch {
                print("No user found for id: \(userId)")
            }
            
            DispatchQueue.main.async {
                completion(user)
            }
        }
        .resume()
    }
    
    
    func updateUser(user: User, completion: @escaping (User) -> ()) {
        guard let url = URL(string: "\(Constants.baseUrl)/users/id/\(user._id)"),
              let accessToken = SettingsManager.sharedInstance.accessToken,
              let body = try? JSONEncoder().encode(UserBody(user: user))
        else { return };
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                fatalError("Failed to update user data: Error: \(error)")
            }
            
            guard let data = data else {
                fatalError("Failed to update user data")
            }
            
            let user = Utils.decodeToObj(User.self, from: data)
            
            DispatchQueue.main.async {
                completion(user)
            }
        }
        .resume()
    }
    
    func createDataBody(withParameters params: [String: String]?, media: [Media]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }

    
    func uploadImage(image: UIImage, completion: @escaping (UploadImageResponse) -> ()) {
        guard let url = URL(string: "\(Constants.baseUrl)/images/upload/"),
//              let accessToken = SettingsManager.sharedInstance.accessToken,
              let mediaImage = Media(withImage: image, forKey: "image")
        else { return };
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
//        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        
        let parameters = ["enctype": "multipart/form-data"]
        let boundary = "Boundary-\(UUID().uuidString)"

        let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(String(dataBody.count), forHTTPHeaderField: "Content-Length")
        request.httpBody = dataBody
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                fatalError("Failed to upload image: Error: \(error)")
            }
            guard let data = data else {
                fatalError("Failed to get response from uploading image")
            }
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print(jsonResult)
                }
            } catch let parseError {
                fatalError("JSON Error \(parseError.localizedDescription)")
            }
            
            
            let response = Utils.decodeToObj(UploadImageResponse.self, from: data)
            DispatchQueue.main.async {
                completion(response)
            }
        }
        .resume()
    }
    
//    func downloadImage(filename: String, completion: @escaping (UIImage) -> ()) {
//        guard let url = URL(string: "\(Constants.baseUrl)/images/download/"),
//              let accessToken = SettingsManager.sharedInstance.accessToken
//        else { return };
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        
//        URLSession.shared.dataTask(with: request) {(data, response, error) in
//            if let error = error {
//                fatalError("Failed to download image: Error: \(error)")
//            }
//            guard let data = data,
//                  let image = UIImage(data: data) else {
//                fatalError("Failed to download image image")
//            }
//            DispatchQueue.main.async {
//                completion(image)
//            }
//        }
//        .resume()
//    }
    
//    func downloadProfileImage(completion: @escaping (UIImage) -> ()) {
//        guard let url = URL(string: "\(Constants.baseUrl)/images/profile/"),
//              let accessToken = SettingsManager.sharedInstance.accessToken
//        else { return };
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        
//        URLSession.shared.dataTask(with: request) {(data, response, error) in
//            if let error = error {
//                fatalError("Failed to download profile image: Error: \(error)")
//            }
//            guard let data = data,
//                  let image = UIImage(data: data) else {
//                fatalError("Failed to download profile image")
//            }
//            DispatchQueue.main.async {
//                completion(image)
//            }
//        }
//        .resume()
//    }
    
    func updateProfile(image: UIImage, completion: @escaping (UploadImageResponse) -> ()) {
        guard let url = URL(string: "\(Constants.baseUrl)/images/profile"),
              let accessToken = SettingsManager.sharedInstance.accessToken,
              let mediaImage = Media(withImage: image, forKey: "image")
        else { return };
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        
        let parameters = ["enctype": "multipart/form-data"]
        let boundary = "Boundary-\(UUID().uuidString)"
        
        let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(String(dataBody.count), forHTTPHeaderField: "Content-Length")
        request.httpBody = dataBody
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                fatalError("Failed to upload image: Error: \(error)")
            }
            guard let data = data else {
                fatalError("Failed to get response from uploading image")
            }
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print(jsonResult)
                }
            } catch let parseError {
                fatalError("JSON Error \(parseError.localizedDescription)")
            }
            
            
            let response = Utils.decodeToObj(UploadImageResponse.self, from: data)
            DispatchQueue.main.async {
                completion(response)
            }
        }
        .resume()
    }
    
    func deleteProfileImage(completion: @escaping (String) -> ()) {
        guard let url = URL(string: "\(Constants.baseUrl)/images/profile"),
              let accessToken = SettingsManager.sharedInstance.accessToken
        else { return };
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                fatalError("Failed to delete profile image: Error: \(error)")
            }
            
            guard let data = data else {
                fatalError("Failed to delete profile image")
            }
            
            let msg = Utils.decodeToObj([String: String].self, from: data)
            
            DispatchQueue.main.async {
                completion(msg["message"] ?? "")
            }
        }
        .resume()
    }
}

