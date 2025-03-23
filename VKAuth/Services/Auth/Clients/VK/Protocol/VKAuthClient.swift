//
//  VKAuthClient.swift
//  VKAuth
//
//  Created by Vlad on 21.03.25.
//

import Foundation

protocol VKAuthClient: AnyObject {
    func generateSafariAuthURL() -> URL?
    func requestTokens(url: URL, completion: @escaping (Result<VKToken, NetworkError>) -> Void)
    func refreshTokens(_ vkToken: VKToken, completion: @escaping (Result<VKToken, NetworkError>) -> Void)
    func invalidateToken(_ vkToken: VKToken, completion: @escaping (Result<Void, AuthError>) -> Void)
}
