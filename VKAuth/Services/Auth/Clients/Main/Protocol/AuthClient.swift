//
//  AuthClient.swift
//  VKAuth
//
//  Created by Vlad on 21.03.25.
//

import Foundation

protocol AuthClient: AnyObject {
    var delegate: AuthClientDelegate? { get set }
    func handleAuthCallbackURL(url: URL)
    func requestAuthorization(type: AuthType, completion: @escaping (Result<Token, AuthError>) -> Void)
    func refreshToken(authType: AuthType, token: Token, completion: @escaping (Result<Token, AuthError>) -> Void)
    func invalidateToken(authType: AuthType, token: Token, completion: @escaping (Result<Void, AuthError>) -> Void)
}
