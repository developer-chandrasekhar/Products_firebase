//
//  SplashViewModel.swift
//  POC
//
//  Created by chandra sekhar p on 05/08/24.
//

import Foundation
import FirebaseCore
import FirebaseAuth

@MainActor
final class SplashViewModel: ObservableObject {
   
    @Published public var showErrorMessage = false
    public var errorMessage = ""
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    private let authService: AuthService
    
    init(authService: AuthService = AuthWebService()) {
        self.authService = authService
    }
}

extension SplashViewModel {
    public func validateUser() {
        
        let root: (AppRoots) -> Void = { root in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                AppRootManager.manager.currentRoot = root
            }
        }
        
        Task {
            do {
                let user = try await authService.validateUser()
                root(user != nil ? .home : .login)
            }
            catch _ as UserAuthError {
                root(.login)
            }
            catch let error as NSError {
                handleAuthError(error: error)
            }
            catch {
                root(.login)
            }
        }
    }
    
    func handleAuthError(error: NSError) {
        if let authErrorCode = AuthErrorCode(rawValue: error.code) {
            switch authErrorCode {
            case .userTokenExpired:
                AppRootManager.manager.currentRoot = .login
            case .networkError:
                errorMessage = "Network error. Please check your connection."
            case .userNotFound:
                AppRootManager.manager.currentRoot = .login
            default:
                errorMessage = "An unknown error occurred: \(error.localizedDescription)"
            }
        }
        else {
            errorMessage = "An unknown error occurred: \(error.localizedDescription)"
        }
        print(errorMessage)
    }
}
