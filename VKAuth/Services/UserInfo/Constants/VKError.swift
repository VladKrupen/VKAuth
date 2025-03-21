//
//  VKError.swift
//  VKAuth
//
//  Created by Vlad on 21.03.25.
//

import Foundation

enum VKError: String {
    case accessDenied = "access_denied"
    case invalidToken = "invalid_token"
    case serverError = "server_error"
    case internalServerError = "500 Internal Server Error"
    case slowDown = "slow_down"
    case temporarilyUnavailable = "temporarily_unavailable"
    case serviceUnavailable = "503 Service Unavailable"
    case invalidClient = "invalid_client"
    case unknown
}

// MARK: - Init

extension VKError {
    init(rawValue: String) {
        switch rawValue {
        case "access_denied":
            self = .accessDenied
        case "invalid_token":
            self = .invalidToken
        case "server_error":
            self = .serverError
        case "500 Internal Server Error":
            self = .internalServerError
        case "slow_down":
            self = .slowDown
        case "temporarily_unavailable":
            self = .temporarilyUnavailable
        case "503 Service Unavailable":
            self = .serviceUnavailable
        case "invalid_client":
            self = .invalidClient
        default:
            self = .unknown
        }
    }
}
