//
//  VKUser.swift
//  VKAuth
//
//  Created by Vlad on 20.03.25.
//

import Foundation

struct VKUser: Codable, User {
    let userID: String
    let firstName: String
    let lastName: String
    let phone: String?
    let avatar: String?
}

// MARK: - CodingKeys

extension VKUser {
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case phone
        case avatar
    }
}
