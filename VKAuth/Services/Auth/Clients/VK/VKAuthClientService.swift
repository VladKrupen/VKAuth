//
//  VKAuthClientService.swift
//  VKAuth
//
//  Created by Vlad on 18.03.25.
//

import Foundation
import CryptoKit

final class VKAuthClientService: VKAuthClient {
    static let clientId: String = "53279842"
    
    private let authURLString: String = "https://id.vk.com/authorize"
    private let redirectUri: String = "vk53279842://vk.com/blank.html"
    private let state: String = "welcomeToApp"
    private let codeChallengeMethod: String = "S256"
    private let responseType: String = "code"
    private let prompt: String = "login"
    private let scope: String = "vkid.personal_info"
    private let codeVerifier: String
    private let codeChallenge: String
    
    private let httpService: URLSessionHTTPService
    
    init(httpService: URLSessionHTTPService) {
        self.codeVerifier = Self.generateCodeVerifier()
        self.codeChallenge = Self.createCodeChallenge(from: codeVerifier)
        self.httpService = httpService
    }
    
    static private func generateCodeVerifier() -> String {
        let characters = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        var codeVerifier = ""
        for _ in 0..<43 {
            let randomIndex = Int(arc4random_uniform(UInt32(characters.count)))
            codeVerifier.append(characters[randomIndex])
        }
        return codeVerifier
    }
    
    static private func createCodeChallenge(from verifier: String) -> String {
        let data = verifier.data(using: .utf8)!
        let hash = SHA256.hash(data: data)
        return Data(hash).base64EncodedString()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}

// MARK: - Authorization

extension VKAuthClientService {
    func generateSafariAuthURL() -> URL? {
        var urlComponents = URLComponents(string: authURLString)
        urlComponents?.queryItems = [
            AuthQueryItem.clientId.queryItem(value: Self.clientId),
            AuthQueryItem.redirectUri.queryItem(value: redirectUri),
            AuthQueryItem.state.queryItem(value: state),
            AuthQueryItem.codeChallenge.queryItem(value: codeChallenge),
            AuthQueryItem.codeChallengeMethod.queryItem(value: codeChallengeMethod),
            AuthQueryItem.responseType.queryItem(value: responseType),
            AuthQueryItem.prompt.queryItem(value: prompt),
            AuthQueryItem.scope.queryItem(value: scope)
        ]
        return urlComponents?.url
    }
    
    func requestTokens(url: URL, completion: @escaping (Result<VKToken, NetworkError>) -> Void) {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let state = urlComponents.queryItems?.first(where: { $0.name == AuthQueryItem.state.rawValue })?.value,
              let code = urlComponents.queryItems?.first(where: { $0.name == AuthQueryItem.code.rawValue })?.value,
              let deviceId = urlComponents.queryItems?.first(where: { $0.name == AuthQueryItem.deviceId.rawValue })?.value,
              state == self.state else {
            completion(.failure(.parseURLError))
            return
        }
        
        let postRequest = NetworkingPostRequest(urlString: "https://id.vk.com/oauth2/auth")
        let bodyDictionary: [String: String] = [
            "code": code,
            "code_verifier": codeVerifier,
            "client_id": Self.clientId,
            "grant_type": "authorization_code",
            "redirect_uri": redirectUri,
            "state": state,
            "device_id": deviceId
        ]
        
        postRequest.bodyDictionary = bodyDictionary
        
        httpService.makeRequest(request: postRequest) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                let decodeResult = self.decodeVKToken(data, deviceId: deviceId)
                completion(decodeResult)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Token Refresh

extension VKAuthClientService {
    func refreshTokens(_ vkToken: VKToken, completion: @escaping (Result<VKToken, NetworkError>) -> Void) {
        let postRequest = NetworkingPostRequest(urlString: "https://id.vk.com/oauth2/auth")
        let bodyDictionary: [String: String] = [
            "grant_type": "refresh_token",
            "refresh_token": vkToken.refreshToken,
            "device_id": vkToken.deviceId ?? "",
            "client_id": Self.clientId
        ]
        
        postRequest.bodyDictionary = bodyDictionary
        
        httpService.makeRequest(request: postRequest) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                let decodeResult = self.decodeVKToken(data, deviceId: vkToken.deviceId ?? "")
                completion(decodeResult)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Decode

extension VKAuthClientService {
    private func decodeVKToken(_ data: Data, deviceId: String) -> Result<VKToken, NetworkError> {
        do {
            var vkToken = try JSONDecoder().decode(VKToken.self, from: data)
            vkToken.deviceId = deviceId
            return .success(vkToken)
        } catch {
            return .failure(.decodingError(error))
        }
    }
}
