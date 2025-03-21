//
//  RefreshTokenClient.swift
//  VKAuth
//
//  Created by Vlad on 21.03.25.
//

import Foundation

protocol RefreshTokenClient: AnyObject {
    func refreshToken(authType: AuthType, token: Token, completion: @escaping (Result<Token, RefreshTokenError>) -> Void)
}
