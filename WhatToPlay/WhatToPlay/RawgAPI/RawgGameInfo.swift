//
//  GameInfo.swift
//  WhatToPlay
//
//  Created by user227427 on 12/4/22.
//

import Foundation

class RawgGameInfo: Codable, Equatable {
    let gameID: Int64
    let name: String
    let rating: Double
    let imageURL: URL?
    //let platforms: [Platforms]
    
    enum CodingKeys: String, CodingKey {
        case gameID = "id"
        case name
        case rating
        case imageURL = "background_image"
    }
    
    init(gameID: Int64, name: String, rating: Double, imageURL: URL?) {
        self.gameID = gameID
        self.name = name
        self.rating = rating
        self.imageURL = imageURL
    }
    
    static func ==(lhs: RawgGameInfo, rhs: RawgGameInfo) -> Bool {
        return lhs.gameID == rhs.gameID
    }
}
