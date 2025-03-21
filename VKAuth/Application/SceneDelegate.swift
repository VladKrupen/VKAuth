//
//  SceneDelegate.swift
//  VKAuth
//
//  Created by Vlad on 17.03.25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let mainCoordinator = CoordinatorBuilder.createMainCoordinator(navigationController: UINavigationController())

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = mainCoordinator.navigationController
        mainCoordinator.start()
        window.overrideUserInterfaceStyle = .light
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        let url = URLContexts.first?.url
        handleAuthURL(url: url)
    }
}

// MARK: - URL Handling

extension SceneDelegate {
    func handleAuthURL(url: URL?) {
        if let authViewController = getCurrentViewController() as? AuthViewController {
            authViewController.processAuthCallbackURL(url: url)
        }
    }
}

// MARK: - View Controller Helpers

extension SceneDelegate {
    private func getCurrentViewController() -> UIViewController? {
        guard let rootViewController = window?.rootViewController else { return nil }
        if let navigationController = rootViewController as? UINavigationController {
            return navigationController.visibleViewController
        }
        return rootViewController
    }
}

