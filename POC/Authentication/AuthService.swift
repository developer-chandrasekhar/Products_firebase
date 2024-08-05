//
//  AuthService.swift
//  POC
//
//  Created by chandra sekhar p on 02/08/24.
//

import Foundation
import FirebaseCore
import FirebaseAuth

struct UserModel: Codable {
    
    let userId: String
    let email: String?
    let phone: String?
    let photoUrl: String?
    
    init(userId: String, email: String?, phone: String?, photoUrl: String?) {
        self.userId = userId
        self.email = email
        self.phone = phone
        self.photoUrl = photoUrl
    }
}

enum UserAuthError: Error {
    case notAuthenticated
}

protocol AuthService {
    func validateUser() async throws -> User?
    func signInUser(email: String, password: String) async throws -> User
    func createUser(email: String, password: String) async throws -> User
}

struct AuthWebService: AuthService {
    func validateUser() async throws -> User? {
        guard let currentUser = Auth.auth().currentUser else { throw UserAuthError.notAuthenticated }
        do {
            try await currentUser.reload()
            return currentUser
        }
        catch { throw error }
    }
    
    func createUser(email: String, password: String) async throws -> User {
        do {
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            return authDataResult.user
        }
        catch { throw error }
    }
    
    func signInUser(email: String, password: String) async throws -> User {
        do {
            let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
            return authDataResult.user
        }
        catch { throw error }
    }
}
