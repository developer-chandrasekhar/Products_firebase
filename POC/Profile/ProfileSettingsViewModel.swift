//
//  ProfileSettingsViewModel.swift
//  POC
//
//  Created by chandra sekhar p on 06/08/24.
//

import Foundation

class ProfileSettingsViewModel: ObservableObject {
    
    private var authService: AuthService
    private var userService: UserService
    
    init(authService: AuthService = AuthWebService(),
         userService: UserService = UserWebService()) {
        self.authService = authService
        self.userService = userService
    }
}

extension ProfileSettingsViewModel {
    func logout() {
        Task {
            do {
                try authService.logout()
                AppRootManager.manager.currentRoot = .login
            }
        }
    }
    
    func deleteAccount() {
        Task {
            if let userId = SessionManager.shared.user?.userId {
               let result = try await userService.deleteUser(userId: userId)
                if result == true {
                    authService.deleteAccount()
                    AppRootManager.manager.currentRoot = .login
                }
            }
        }
    }
}
