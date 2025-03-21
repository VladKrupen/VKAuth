//
//  ModuleBuilder.swift
//  VKAuth
//
//  Created by Vlad on 17.03.25.
//

import Foundation

final class ModuleBuilder {
    
    // MARK: - Modules
    
    static func createAuthModule(onAction: @escaping (AuthViewModel.Action) -> Void) -> AuthViewController {
        let viewModel = AuthViewModel(
            networkClient: ServiceManager.networkClientService,
            onAction: onAction
        )
        let viewController = AuthViewController(viewModel: viewModel)
        return viewController
    }
    
    static func createProfileModule() -> ProfileViewController {
        let viewModel = ProfileViewModel(networkClient: ServiceManager.networkClientService)
        let viewController = ProfileViewController(viewModel: viewModel)
        return viewController
    }
}
