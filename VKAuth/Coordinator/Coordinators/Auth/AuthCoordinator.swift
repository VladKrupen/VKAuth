//
//  AuthCoordinator.swift
//  VKAuth
//
//  Created by Vlad on 17.03.25.
//

import UIKit

final class AuthCoordinator: Coordinator {
    var flowCompletionHandler: () -> Void
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, flowCompletionHandler: @escaping () -> Void) {
        self.navigationController = navigationController
        self.flowCompletionHandler = flowCompletionHandler
    }
    
    func start() {
        showAuthModule()
    }
    
    private func showAuthModule() {
        let authController = ModuleBuilder.createAuthModule { [weak self] action in
            switch action {
            case .authWithURL(let authType, let authURL):
                self?.openAuthURL(for: authType, url: authURL)
            case .finish:
                self?.flowCompletionHandler()
            }
        }
        
        navigationController.setViewControllers([authController], animated: true)
    }
    
    private func openAuthURL(for authType: AuthType, url: URL?) {
        switch authType {
        case .vk:
            guard let url else { return }
            guard UIApplication.shared.canOpenURL(url) else { return }
            UIApplication.shared.open(url)
        }
    }
}
