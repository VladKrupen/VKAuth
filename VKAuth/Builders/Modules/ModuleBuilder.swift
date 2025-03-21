//
//  ModuleBuilder.swift
//  VKAuth
//
//  Created by Vlad on 17.03.25.
//

import Foundation

final class ModuleBuilder {
    
    // MARK: - Services
    
    static private let httpService = URLSessionHTTPService()
    static private let vkAuthClient = VKAuthClientService(httpService: httpService)
    static private let authClientService = AuthClientService(
        keychainService: keychainService,
        vkAuthClient: vkAuthClient
    )
    static private let keychainService = KeychainService()
    
    // MARK: - Modules
    
    static func createAuthModule(onAction: @escaping (AuthViewModel.Action) -> Void) -> AuthViewController {
        let viewModel = AuthViewModel(
            authClientService: authClientService,
            onAction: onAction
        )
        let viewController = AuthViewController(viewModel: viewModel)
        return viewController
    }
    
    static func createProfileModule() -> ProfileViewController {
        let viewModel = ProfileViewModel(
            authClient: authClientService
        )
        let viewController = ProfileViewController(viewModel: viewModel)
        return viewController
    }
}
