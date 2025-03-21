//
//  ProfileCoordinator.swift
//  VKAuth
//
//  Created by Vlad on 19.03.25.
//

import UIKit

final class ProfileCoordinator: Coordinator {
    var flowCompletionHandler: () -> Void
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, flowCompletionHandler: @escaping () -> Void) {
        self.navigationController = navigationController
        self.flowCompletionHandler = flowCompletionHandler
    }
    
    func start() {
        showProfileModule()
    }
    
    private func showProfileModule() {
        let profileController = ModuleBuilder.createProfileModule()
        navigationController.setViewControllers([profileController], animated: true)
    }
}
