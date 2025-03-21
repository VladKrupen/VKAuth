//
//  AppCoordinator.swift
//  VKAuth
//
//  Created by Vlad on 17.03.25.
//

import UIKit

protocol AppCoordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}
