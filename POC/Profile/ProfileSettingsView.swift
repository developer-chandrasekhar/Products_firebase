//
//  ProfileSettingsView.swift
//  POC
//
//  Created by chandra sekhar p on 06/08/24.
//

import SwiftUI

struct ProfileSettingsView: View {
    
    @State var showDeleteAccountAlert = false
    @State var showLogoutAccountAlert = false
    @ObservedObject var viewModel: ProfileSettingsViewModel
    
    init(viewModel: ProfileSettingsViewModel = ProfileSettingsViewModel()) {
        self.viewModel = viewModel
    }
    
    let logoutAccountMessage = "Are you sure, you want to logout?"
    let deleteAccountMessage = "If you delete your account, your details permanently removed with us after 30 days."
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            profileItem(headerTitle: "Logout:", contentTitle: "Logout") {
                self.showLogoutAccountAlert.toggle()
            }
            .padding(.top, 24)
            profileItem(headerTitle: "Delete Account:", contentTitle: "Delete account", infoString: "Note: " + deleteAccountMessage, contentColor: .red) {
                self.showDeleteAccountAlert.toggle()
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.3))
        .navigationTitle("Account Settings")
        .navigationBarTitleDisplayMode(.inline)
        .alert(deleteAccountMessage, isPresented: $showDeleteAccountAlert) {
            Button("Delete") {
                viewModel.deleteAccount()
            }
            Button("Cancel") {}
        }
        .alert(logoutAccountMessage, isPresented: $showLogoutAccountAlert) {
            Button("Logout") {
                viewModel.logout()
            }
            Button("Cancel") {}
        }
    }
    
    func profileItem(headerTitle: String, contentTitle: String, infoString: String = "", contentColor: Color = .black, contentAction: (() -> Void)? = nil) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(headerTitle)
                .padding(.leading)
                .font(.system(size: 14))
                .foregroundColor(.black.opacity(0.7))
            HStack {
                Text(contentTitle).bold()
                    .foregroundStyle(contentColor)
                    .padding(.leading)
                    .font(.system(size: 16))
                Spacer()
            }
            .padding(.vertical)
            .background(Rectangle().fill(.white))
            .frame(maxWidth: .infinity)
            .onTapGesture {
                contentAction?()
            }
            Text(infoString)
                .padding(.leading)
                .font(.system(size: 12))
                .foregroundColor(.black.opacity(0.7))
        }
        
    }
}

#Preview {
    ProfileSettingsView()
}

