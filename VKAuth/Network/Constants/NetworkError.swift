//
//  NetworkError.swift
//  VKAuth
//
//  Created by Vlad on 19.03.25.
//

import Foundation

enum NetworkError: LocalizedError {
    case parseURLError
    case serverError(Swift.Error)
    case invalidURL
    case invalidResponse
    case invalidData
    case decodingError(Swift.Error)
    case invalidTokenType
}
