//
//  LoginStore.swift
//  WhatToPlay
//
//  Created by Kris Calma on 12/5/22.
//

import Foundation

class LoginStore {
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func login(
        parameters: [String:String]?,
        completion: @escaping (Result<AuthInfo, Error>) -> Void
    ) {
        let url = AuthAPI.loginURL(parameters: parameters)
        
        // Prepare request object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            if let error = error {
                print("ERROR: \(error)")
                return
            }
            
            let result = self.processLoginRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
    
    private func processLoginRequest(
        data: Data?,
        error: Error?
    ) -> Result<AuthInfo, Error> {
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return AuthAPI.results(fromJSON: jsonData)
    }
}
