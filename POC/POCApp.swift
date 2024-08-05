//
//  POCApp.swift
//  POC
//
//  Created by chandra sekhar p on 02/08/24.
//

import SwiftUI
import SwiftData

enum AppRoots {
    case splash
    case login
    case signUp
    case home
}

@main
struct POCApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject private var appRoot = AppRootManager.manager

    var body: some Scene {
        WindowGroup {
            Group {
                switch appRoot.currentRoot {
                case .splash: SplashView()
                case .login: LoginView(viewModel: LoginViewModel())
                case .signUp: EmptyView()
                case .home: EmptyView()
                }
            }
        }
    }
}

final class AppRootManager: ObservableObject {
    
    @Published var currentRoot: AppRoots
    static var manager: AppRootManager = { return AppRootManager() }()
    
    private init(currentRoot: AppRoots = .splash) {
        self.currentRoot = .splash
    }
}
