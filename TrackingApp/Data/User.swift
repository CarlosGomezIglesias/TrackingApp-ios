//
//  User.swift
//  TrackingApp
//
//  Created by Tardes on 5/6/26.
//

import Foundation

struct User: Codable, Sendable {
    let id: String
    let username: String
    let firstName: String
    let lastName: String
    let gender: Int
    let birthDate: Int64?
    let profileImageUrl: String?
    
    func fullName() -> String {
        return "\(firstName) \(lastName)"
    }
    
    
}
