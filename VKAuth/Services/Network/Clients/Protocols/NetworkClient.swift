//
//  NetworkClient.swift
//  VKAuth
//
//  Created by Vlad on 21.03.25.
//

import Foundation

protocol NetworkClient: AnyObject {
    var delegate: NetworkClientDelegate? { get set }
    func requestAuthorization(type: AuthType, completion: @escaping (Result<Void, NetworkClientError>) -> Void)
    func handleAuthCallbackURL(url: URL)
    func fetchUserInfo(completion: @escaping (Result<User, NetworkClientError>) -> Void)
}
