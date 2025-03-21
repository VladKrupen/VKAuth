//
//  NetworkClientDelegate.swift
//  VKAuth
//
//  Created by Vlad on 21.03.25.
//

import Foundation

protocol NetworkClientDelegate: AnyObject {
    func authorizationSafariURL(authType: AuthType, url: URL?)
    func didFailAuthorization(with error: NetworkClientError)
}
