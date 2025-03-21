//
//  VKUserInfoClient.swift
//  VKAuth
//
//  Created by Vlad on 21.03.25.
//

import Foundation

protocol VKUserInfoClient: AnyObject {
    func fetchVKUserInfo(vkToken: VKToken, completion: @escaping (Result<VKUser, UserInfoClientError>) -> Void)
}
