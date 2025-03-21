//
//  VKUserInfoClientService.swift
//  VKAuth
//
//  Created by Vlad on 21.03.25.
//

import Foundation

final class VKUserInfoClientService {
    private let httpService: URLSessionHTTPService
    
    init(httpService: URLSessionHTTPService) {
        self.httpService = httpService
    }
}

// MARK: - VKUserInfoClient

extension VKUserInfoClientService: VKUserInfoClient {
    func fetchVKUserInfo(vkToken: VKToken, completion: @escaping (Result<VKUser, UserInfoClientError>) -> Void) {
        let postRequest = NetworkingPostRequest(urlString: "https://id.vk.com/oauth2/user_info")
        let bodyDictionary: [String: String] = [
            "client_id": VKAuthClientService.clientId
        ]
        postRequest.accessToken = vkToken.accessToken
        postRequest.bodyDictionary = bodyDictionary
        
        httpService.makeRequest(request: postRequest) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                let decodeResult = decodeVKUser(data)
                completion(decodeResult)
            case .failure(let error):
                completion(.failure(.networkError(error)))
            }
        }
    }
}

// MARK: - Decode

extension VKUserInfoClientService {
    private func decodeVKUser(_ data: Data) -> Result<VKUser, UserInfoClientError> {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            guard let userDictionary = json?["user"] as? [String: Any] else {
                return .failure(.invalidJsonFormat("The data is not a dictionary"))
            }
            
            let userData = try JSONSerialization.data(withJSONObject: userDictionary, options: [])
            let vkUser = try JSONDecoder().decode(VKUser.self, from: userData)
            
            return .success(vkUser)
        } catch {
            return .failure(.decodingError(error))
        }
    }
}
