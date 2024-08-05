//
//  UserService.swift
//  POC
//
//  Created by chandra sekhar p on 06/08/24.
//

import Foundation
import FirebaseFirestore

struct UserModel: Codable {
    
    let userId: String
    let email: String?
    let phoneNumber: String?
    let photoUrl: String?
    
    init(userId: String, email: String?, phoneNumber: String?, photoUrl: String?) {
        self.userId = userId
        self.email = email
        self.phoneNumber = phoneNumber
        self.photoUrl = photoUrl
    }
    
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case phoneNumber = "phone_number"
        case photoUrl = "photo_url"
        case email
    }
    
    // Decode from JSON
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decode(String.self, forKey: .userId)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
    }
    
    // Encode to JSON
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
        try container.encode(email, forKey: .email)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(photoUrl, forKey: .photoUrl)
    }
}

protocol UserService {
    func createUserProfile(user: UserModel) async throws -> UserModel
    func getUserProfile(userId: String) async throws -> UserModel
}

extension UserService {
    
    var userCollection: CollectionReference {
        return Firestore.firestore().collection("users")
    }
    
    func userDocument(userId: String) -> DocumentReference {
        return userCollection.document(userId)
    }
}

struct UserWebService: UserService {
    func getUserProfile(userId: String) async throws -> UserModel {
        do {
           return try await userCollection.document(userId).getDocument(as: UserModel.self)
        }
        catch { throw error }
    }
    
    func createUserProfile(user: UserModel) async throws -> UserModel {
        do {
            try userDocument(userId: user.userId).setData(from: user, merge: false)
            return user
        }
        catch { throw error }
    }
}
