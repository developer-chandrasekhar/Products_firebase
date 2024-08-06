
//  LoginViewModel.swift
//  POC
//  Created by chandra sekhar p on 02/08/24.

import Foundation
import FirebaseCore
import FirebaseAuth

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

enum AuthenticationFlow {
    case login
    case signUp
}

enum AuthenticationError: Error {
    case tokenError(message: String)
}

@MainActor
final class LoginViewModel: ObservableObject {
    
    @Published public var email: String = ""
    @Published public var password: String = ""
    @Published public var isValid: Bool  = false
    @Published public var authenticationState: AuthenticationState = .unauthenticated
    @Published public var displayName: String = ""
    @Published public var flow: AuthenticationFlow = .login
    public var errorMessage: String = ""

    private var authStateHandler: AuthStateDidChangeListenerHandle?
    private let authService: AuthService
    private let userService: UserService

    
    init(authService: AuthService = AuthWebService(), userService: UserService = UserWebService()) {
        self.authService = authService
        self.userService = userService
        localFlowValidation()
    }
    
    private func localFlowValidation() {
        $isValid
            .combineLatest($email, $password)
            .map { flow, email, password in
                !(email.isEmpty || password.isEmpty)
            }
            .assign(to: &$isValid)
    }
}

// signIn With Email and Password
extension LoginViewModel {
    func signInWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do {
            let firUser = try await authService.signInUser(email: email, password: password)
            let user = try await userService.getUserProfile(userId: firUser.uid)
            SessionManager.shared.user = user
            return true
        }
        catch  {
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
}
