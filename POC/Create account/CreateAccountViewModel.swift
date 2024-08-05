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
    @Published public var flow: AuthenticationFlow = .signUp
    public var errorMessage: String = ""
    private let authService: AuthService
    private let userService: UserService

    init(authService: AuthService = AuthWebService(), userService: UserWebService = UserWebService()) {
        self.authService = authService
        self.userService = userService
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
           let user = try await authService.createUser(email: email, password: password)
            let userModel = try await userService.createUserProfile(user: UserModel(userId: user.uid, email: user.email, phoneNumber: "123456789", photoUrl: "https://github.com/developer-chandrasekhar/develop-sample-images/blob/main/notification-image.png"))
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
