//
//  AuthAPI.swift
//  WhatToPlay
//
//  Created by Kris Calma on 12/5/22.
//

import Foundation

enum AuthEndPoint: String {
    case login = "login"
    case signup = "signup"
}

struct AuthAPI {
    private static let baseURLString = "https://fossil-jagged-pantry.glitch.me/"
    
    private static func authURL(
        endPoint: AuthEndPoint,
        parameters: [String:String]?
    ) -> URL {
        let endpoint = self.baseURLString + endPoint.rawValue
        var components = URLComponents(string: endpoint)!
        var queryItems = [URLQueryItem]()
        
        // Tack on additional query parameters
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                if (value != "") {
                    queryItems.append(item)
                }
            }
        }
        
        components.queryItems = queryItems
        
        return components.url!
    }
    
    static func loginURL(parameters: [String:String]?) -> URL {
        return authURL(
            endPoint: AuthEndPoint.login,
            parameters: parameters
        )
    }
    
    static func signupURL(parameters: [String:String]?) -> URL {
        return authURL(
            endPoint: AuthEndPoint.signup,
            parameters: parameters
        )
    }
    
    static func results(fromJSON data: Data) -> Result<AuthInfo, Error> {
        do {
            let decoder = JSONDecoder()
            let authResponse = try decoder.decode(AuthInfo.self, from: data)
            return .success(authResponse)
        } catch {
            return .failure(error)
        }
    }
}
