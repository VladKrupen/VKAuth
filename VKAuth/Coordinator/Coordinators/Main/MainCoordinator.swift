//
//  MainCoordinator.swift
//  VKAuth
//
//  Created by Vlad on 17.03.25.
//

import UIKit

final class MainCoordinator: AppCoordinator {
    var navigationController: UINavigationController
    private var childCoordinators: [Coordinator] = .init()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard AppConfig.shared.authType != nil else {
            showAuthFlow()
            return
        }
        showProfileFlow()
    }
    
    private func showAuthFlow() {
        let authCoordinator = CoordinatorBuilder.createAuthCoordinator(navigationController: navigationController) { [weak self] in
            if AppConfig.shared.authType != nil {
                self?.showProfileFlow()
            }
        }
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }
    
    private func showProfileFlow() {
        let profileCoordinator = CoordinatorBuilder.createProfileCoordinator(navigationController: navigationController) { [weak self] in
            AppConfig.shared.authType = nil
            self?.childCoordinators = .init()
            self?.showAuthFlow()
        }
        childCoordinators.append(profileCoordinator)
        profileCoordinator.start()
    }
}
