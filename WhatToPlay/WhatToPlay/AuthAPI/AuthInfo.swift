//
//  AuthInfo.swift
//  WhatToPlay
//
//  Created by user227427 on 12/5/22.
//

import Foundation

class AuthInfo: Codable {
    let success: Bool
    let error: Bool
    let msg: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case error
        case msg
    }
}
