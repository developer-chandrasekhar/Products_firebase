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
    let uid: String
    let email: String?
    let phone: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.phone = user.phoneNumber
        self.photoUrl = user.photoURL?.absoluteString
    }
}

enum UserAuthError: Error {
    case notAuthenticated
}

protocol AuthService {
    func validateUser() async throws -> UserModel
    func signInUser(email: String, password: String) async throws -> UserModel
    func createUser(email: String, password: String) async throws -> UserModel
}

struct AuthWebService: AuthService {
    func validateUser() async throws -> UserModel {
        guard let currentUser = Auth.auth().currentUser else { throw UserAuthError.notAuthenticated }
        do {
            try await currentUser.reload()
            return UserModel(user: currentUser)
        }
        catch {
            throw error
        }
    }
    
    func createUser(email: String, password: String) async throws -> UserModel {
        do {
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            return UserModel(user: authDataResult.user)
        }
        catch { throw error }
    }
    
    func signInUser(email: String, password: String) async throws -> UserModel {
        do {
            let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
            return UserModel(user: authDataResult.user)
        }
        catch { throw error }
    }
}
