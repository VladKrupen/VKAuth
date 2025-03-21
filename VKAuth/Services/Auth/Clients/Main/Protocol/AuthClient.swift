//
//  AuthClient.swift
//  VKAuth
//
//  Created by Vlad on 21.03.25.
//

import Foundation

protocol AuthClient: AnyObject {
    func handleAuthCallbackURL(url: URL)
    func requestAuthorization(type: AuthType, completion: @escaping (Result<Void, AuthError>) -> Void)
    func fetchUserInfo(completion: @escaping (Result<User, AuthError>) -> Void)
}
