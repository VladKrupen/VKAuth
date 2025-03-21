//
//  KeychainService.swift
//  VKAuth
//
//  Created by Vlad on 19.03.25.
//

import Foundation
import Security

final class KeychainService {
    func saveTokens<T: Token>(authType: AuthType, token: T, completion: @escaping (Result<Void, KeychainError>) -> Void) {
        guard let data = try? JSONEncoder().encode(token) else {
            completion(.failure(.encodingError))
            return
        }
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: authType.rawValue as CFString,
            kSecValueData: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            completion(.failure(.saveTokenError))
            return
        }
        
        completion(.success(()))
    }
    
    func getTokens(authType: AuthType, completion: @escaping (Result<Token, KeychainError>) -> Void) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: authType.rawValue as CFString,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess, let data = result as? Data else {
            completion(.failure(.tokenNotFoundError))
            return
        }
        
        decodeToken(authType.tokenType, from: data, completion: completion)
    }
}

// MARK: - Error 

extension KeychainService {
    enum KeychainError: LocalizedError {
        case encodingError
        case decodingError
        case saveTokenError
        case tokenNotFoundError
    }
}

// MARK: - Decode

extension KeychainService {
    private func decodeToken<T: Token & Decodable>(_ type: T.Type, from data: Data, completion: @escaping (Result<Token, KeychainError>) -> Void) {
        do {
            let token = try JSONDecoder().decode(T.self, from: data)
            completion(.success(token))
        } catch {
            completion(.failure(.decodingError))
        }
    }
}
