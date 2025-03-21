//
//  Coordinator.swift
//  VKAuth
//
//  Created by Vlad on 17.03.25.
//

import Foundation

protocol Coordinator: AnyObject, AppCoordinator {
    var flowCompletionHandler: () -> Void { get set }
}
