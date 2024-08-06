//
//  SessionManager.swift
//  POC
//
//  Created by chandra sekhar p on 06/08/24.
//

import Foundation

final class SessionManager {
    
    public static let shared = SessionManager()
    public var user: UserModel?

    private init() {}
    
    func logout() {
        user = nil
    }
    
    func deleteAccount() {
        
    }
}
