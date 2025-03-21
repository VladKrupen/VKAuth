//
//  VKToken.swift
//  VKAuth
//
//  Created by Vlad on 18.03.25.
//

import Foundation

struct VKToken: Token {
    let userId: Int
    let accessToken: String
    let refreshToken: String
    var deviceId: String?
}

// MARK: - CodingKeys

extension VKToken {
    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
        case accessToken = "access_token"
        case userId = "user_id"
        case deviceId = "device_id"
    }
}
