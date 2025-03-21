//
//  User.swift
//  VKAuth
//
//  Created by Vlad on 20.03.25.
//

import Foundation

protocol User {
    var userID: String { get }
    var firstName: String { get }
    var lastName: String { get }
    var phone: String? { get }
    var avatar: String { get }
}
