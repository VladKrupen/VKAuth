//
//  ServiceManager.swift
//  VKAuth
//
//  Created by Vlad on 21.03.25.
//

import Foundation

final class ServiceManager {
    
    // MARK: - HTTP
    
    static private let httpService = URLSessionHTTPService()
    
    // MARK: - Auth
    
    static private let vkAuthClient = VKAuthClientService(httpService: httpService)
    static private let authClientService = AuthClientService(vkAuthClient: vkAuthClient)
    
    // MARK: - Storage
    
    static private let keychainService = KeychainService()
    static private let tokenStorageService = TokenStorageService(keychainService: keychainService)
    
    // MARK: - User Info
    
    static private let vkUserInfoClientService = VKUserInfoClientService(httpService: httpService)
    static private let userInfoClientService = UserInfoClientService(vkUserInfoClient: vkUserInfoClientService)
    
    // MARK: - Network
    
    static let networkClientService = NetworkClientService(
                                                    authClient: authClientService,
                                                    tokenStorage: tokenStorageService,
                                                    userInfoClient: userInfoClientService
                                                )
}
