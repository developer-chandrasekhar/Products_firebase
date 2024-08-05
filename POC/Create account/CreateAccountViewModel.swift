//
//  CreateAccountViewModel.swift
//  POC
//
//  Created by chandra sekhar p on 05/08/24.
//

import Foundation

@MainActor
final class CreateAccountViewModel: ObservableObject {
   
    @Published public var email: String = ""
    @Published public var password: String = ""
    @Published public var confirmPassword = ""
    @Published public var isValid: Bool  = false
    @Published public var authenticationState: AuthenticationState = .unauthenticated
    @Published public var user: UserModel?
    @Published public var flow: AuthenticationFlow = .signUp
    public var errorMessage: String = ""
    private let authService: AuthService
    
    init(authService: AuthService = AuthWebService()) {
        self.authService = authService
        localFlowValidation()
    }
    
    private func localFlowValidation() {
        $flow
            .combineLatest($email, $password, $confirmPassword)
            .map { flow, email, password, confirmPassword in
                !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty || (password != confirmPassword))
            }
            .assign(to: &$isValid)
    }
}

extension CreateAccountViewModel {
    func createAccountWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do  {
            user = try await authService.createUser(email: email, password: password)
            return true
        }
        catch {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
}
