//
//  URLSessionHTTPService.swift
//  VKAuth
//
//  Created by Vlad on 19.03.25.
//

import Foundation

final class URLSessionHTTPService {
    private let urlSession: URLSession = .shared
    
    func makeRequest(request: NetworkingPostRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let urlRequest = request.makeURLRequest() else {
            completion(.failure(.invalidURL))
            return
        }
        
        urlSession.dataTask(with: urlRequest) { data, response, error in
            if let error {
                completion(.failure(.serverError(error)))
                return
            }
            
            guard let response else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data else {
                completion(.failure(.invalidData))
                return
            }
            completion(.success(data))
        }
        .resume()
    }
}
