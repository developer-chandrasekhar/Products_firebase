//
//  UserModel.swift
//  POC
//
//  Created by chandra sekhar p on 06/08/24.
//

import Foundation

struct UserModel: Codable {
    
    let userId: String
    let email: String?
    let phoneNumber: String?
    let photoUrl: String?
    var createdDate: Date?
    var favouriteProducts: [Int]?
    
    init(userId: String, email: String?, phoneNumber: String?, photoUrl: String?) {
        self.userId = userId
        self.email = email
        self.phoneNumber = phoneNumber
        self.photoUrl = photoUrl
        self.createdDate = Date()
        self.favouriteProducts = []
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case phoneNumber = "phone_number"
        case photoUrl = "photo_url"
        case createdDate = "crated_date"
        case favouriteProducts = "favourite_products"
        case email
    }
    
    // Decode from JSON
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decode(String.self, forKey: .userId)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        createdDate = try container.decodeIfPresent(Date.self, forKey: .createdDate)
        favouriteProducts = try container.decodeIfPresent([Int].self, forKey: .favouriteProducts)
    }
    
    // Encode to JSON
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
        try container.encode(email, forKey: .email)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(photoUrl, forKey: .photoUrl)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(favouriteProducts, forKey: .favouriteProducts)
    }
}

extension UserModel {
    mutating func setDate() {
        self.createdDate = Date()
    }
}
