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
   
    @Published public var user: UserModel?
    @Published public var showErrorMessage = false
    public var errorMessage = ""
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    private let authService: AuthService
    private var root = AppRoots.splash
    
    
    init(authService: AuthService = AuthWebService()) {
        self.authService = authService
    }
    
    public func redirect() {
        if root != .splash {
            AppRootManager.manager.currentRoot = root
        }
    }
}

extension SplashViewModel {
    public func validateUser() {
        Task {
            do {
                user = try await authService.validateUser()
                AppRootManager.manager.currentRoot = .home
            }
            catch _ as UserAuthError {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    AppRootManager.manager.currentRoot = .login
                }
            }
            catch let error as NSError {
                handleAuthError(error: error)
            }
            catch {
                errorMessage = "An unknown error occurred: \(error.localizedDescription)"
                root = .login
            }
        }
    }
    
    func handleAuthError(error: NSError) {
        if let authErrorCode = AuthErrorCode(rawValue: error.code) {
            switch authErrorCode {
            case .userTokenExpired:
                root = .login
                errorMessage = "Session expired. Please sign in again."
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
