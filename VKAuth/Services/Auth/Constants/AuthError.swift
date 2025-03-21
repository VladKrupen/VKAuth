//
//  AuthError.swift
//  VKAuth
//
//  Created by Vlad on 20.03.25.
//

import Foundation

enum AuthError: LocalizedError {
    case invalidAuth(NetworkError)
}
