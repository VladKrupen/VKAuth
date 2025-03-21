//
//  UserInfoClientService.swift
//  VKAuth
//
//  Created by Vlad on 21.03.25.
//

import Foundation

final class UserInfoClientService {
    private let vkUserInfoClient: VKUserInfoClient
    
    init(vkUserInfoClient: VKUserInfoClient) {
        self.vkUserInfoClient = vkUserInfoClient
    }
}

// MARK: - UserInfoClient

extension UserInfoClientService: UserInfoClient {
    func fetchUserInfo(authType: AuthType, token: Token, completion: @escaping (Result<User, UserInfoClientError>) -> Void) {
        handleAuthType(authType: authType, token: token, completion: completion)
    }
}

// MARK: - Handle

extension UserInfoClientService {
    private func handleAuthType(authType: AuthType, token: Token, completion: @escaping (Result<User, UserInfoClientError>) -> Void) {
        switch authType {
        case .vk:
            fetchVkUserInfo(token: token, completion: completion)
        }
    }
}

// MARK: - VKUserInfo

extension UserInfoClientService {
    private func fetchVkUserInfo(token: Token, completion: @escaping (Result<User, UserInfoClientError>) -> Void) {
        guard let vkToken = token as? VKToken else {
            completion(.failure(.invalidVKToken))
            return
        }
        
        vkUserInfoClient.fetchVKUserInfo(vkToken: vkToken) { result in
            switch result {
            case .success(let vkUser):
                completion(.success(vkUser))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
