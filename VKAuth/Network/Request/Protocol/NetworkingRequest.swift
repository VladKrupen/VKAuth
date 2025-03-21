//
//  NetworkingRequest.swift
//  VKAuth
//
//  Created by Vlad on 21.03.25.
//

import Foundation

protocol NetworkingRequest: AnyObject {
    var bodyDictionary: [String: String]? { get set }
    var accessToken: String? { get set }
    func makeURLRequest() -> URLRequest?
}
