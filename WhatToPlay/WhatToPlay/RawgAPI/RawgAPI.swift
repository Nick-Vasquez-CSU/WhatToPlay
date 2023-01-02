//
//  RawgAPI.swift
//  WhatToPlay
//
//  Created by Kris Calma on 12/3/22.
//

import Foundation

enum EndPoint: String {
    case listGames = "games"
}

struct RawgAPI {
    
    private static let baseURLString = "https://fossil-jagged-pantry.glitch.me/rawg/"
    
    private static func rawgURL(
        endPoint: EndPoint,
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
    
    static func listGamesURL(parameters: [String:String]?) -> URL {
        return rawgURL(endPoint: EndPoint.listGames, parameters: parameters)
    }
    
    struct RawgResponse: Codable {
        let gamesInfo: [RawgGameInfo]
        
        enum CodingKeys: String, CodingKey {
            case gamesInfo = "results"
        }
    }
    
    static func results(fromJSON data: Data) -> Result<[RawgGameInfo], Error> {
        do {
            let decoder = JSONDecoder()
            let rawgResponse = try decoder.decode(RawgResponse.self, from: data)
            let games = rawgResponse.gamesInfo.filter { $0.imageURL != nil }
            return .success(games)
        } catch {
            return .failure(error)
        }
    }
    
}
