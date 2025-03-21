//
//  NetworkingPostRequest.swift
//  VKAuth
//
//  Created by Vlad on 18.03.25.
//

import Foundation

final class NetworkingPostRequest {
    var bodyDictionary: [String: String]?
    var accessToken: String?
    
    private let urlString: String
    private let timeoutSeconds: TimeInterval
    
    // MARK: - Init
    
    init(urlString: String, timeoutSeconds: TimeInterval = 30) {
        self.urlString = urlString
        self.timeoutSeconds = timeoutSeconds
    }
    
    // MARK: - Request
    
    func makeURLRequest() -> URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = RequestRemoteMethod.post.rawValue
        request.timeoutInterval = timeoutSeconds
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "accept")
        if let accessToken {
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        if let bodyDictionary, let bodyData = try? JSONSerialization.data(withJSONObject: bodyDictionary) {
            request.httpBody = bodyData
        }
        
        return request
    }
}
