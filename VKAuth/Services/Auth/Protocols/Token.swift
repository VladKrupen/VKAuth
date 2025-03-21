//
//  Token.swift
//  VKAuth
//
//  Created by Vlad on 18.03.25.
//

import Foundation

protocol Token: Codable {
    var accessToken: String { get }
    var refreshToken: String { get }
}
