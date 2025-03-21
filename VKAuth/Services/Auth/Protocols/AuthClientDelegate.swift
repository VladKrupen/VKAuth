//
//  AuthClientDelegate.swift
//  VKAuth
//
//  Created by Vlad on 18.03.25.
//

import Foundation

protocol AuthClientDelegate: AnyObject {
    func vkAuthorizationSafariURL(url: URL?)
    func didFailAuthorization(with error: NetworkError)
}
