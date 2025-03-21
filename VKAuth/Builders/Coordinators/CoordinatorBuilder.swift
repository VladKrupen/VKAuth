//
//  CoordinatorBuilder.swift
//  VKAuth
//
//  Created by Vlad on 17.03.25.
//

import UIKit

final class CoordinatorBuilder {
    static func createMainCoordinator(navigationController: UINavigationController) -> AppCoordinator {
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        return mainCoordinator
    }
    
    static func createAuthCoordinator(navigationController: UINavigationController, flowCompletionHandler: @escaping () -> Void) -> Coordinator {
        let authCoordinator = AuthCoordinator(navigationController: navigationController, flowCompletionHandler: flowCompletionHandler)
        return authCoordinator
    }
    
    static func createProfileCoordinator(navigationController: UINavigationController, flowCompletionHandler: @escaping () -> Void) -> Coordinator {
        let profileCoordinator = ProfileCoordinator(navigationController: navigationController, flowCompletionHandler: flowCompletionHandler)
        return profileCoordinator
    }
}
