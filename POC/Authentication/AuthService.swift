//
//  AuthService.swift
//  POC
//
//  Created by chandra sekhar p on 02/08/24.
//

import Foundation
import FirebaseCore
import FirebaseAuth

enum UserAuthError: Error {
    case notAuthenticated
}

protocol AuthService {
    func validateUser() async throws -> User?
    func signInUser(email: String, password: String) async throws -> User
    func createUser(email: String, password: String) async throws -> User
    func logout() throws
    func deleteAccount()
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
    
    func logout() throws {
      try Auth.auth().signOut()
    }
    
    func deleteAccount() {
         Auth.auth().currentUser?.delete()
    }
}
