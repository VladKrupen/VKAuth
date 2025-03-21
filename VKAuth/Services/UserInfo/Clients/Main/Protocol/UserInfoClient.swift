//
//  UserInfoClient.swift
//  VKAuth
//
//  Created by Vlad on 21.03.25.
//

import Foundation

protocol UserInfoClient: AnyObject {
    func fetchUserInfo(authType: AuthType, token: Token, completion: @escaping (Result<User, UserInfoClientError>) -> Void)
}
