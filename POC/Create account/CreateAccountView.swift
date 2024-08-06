//
//  CreateAccountView.swift
//  POC
//
//  Created by chandra sekhar p on 05/08/24.
//

import SwiftUI

private enum FocusableField: Hashable {
    case email
    case password
    case confirmPassword
}

struct CreateAccountView: View {
    
    @FocusState private var focus: FocusableField?
    @ObservedObject var viewModel: CreateAccountViewModel = CreateAccountViewModel()
    @Environment(\.dismiss) var dismiss

    @State var showErrorAlert = false
    @State var goToHomeScreen = false
    
    var body: some View {
        VStack {
            Image("login")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 250)
            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Image(systemName: "at")
                TextField("Email", text: $viewModel.email)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .focused($focus, equals: .email)
                    .submitLabel(.next)
                    .onSubmit {
                        self.focus = .password
                    }
            }
            .padding(.vertical, 6)
            .background(Divider(), alignment: .bottom)
            .padding(.bottom, 4)
            
            passwordField(title: "Password", value: $viewModel.password)
            passwordField(title: "Confirm Password", value: $viewModel.confirmPassword)
            
            Button(action: createAccountWithEmailPassword) {
              if viewModel.authenticationState != .authenticating {
                Text("Login")
                  .padding(.vertical, 8)
                  .frame(maxWidth: .infinity)
              }
              else {
                ProgressView()
                  .progressViewStyle(CircularProgressViewStyle(tint: .white))
                  .padding(.vertical, 8)
                  .frame(maxWidth: .infinity)
              }
            }
            .disabled(!viewModel.isValid)
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
            .padding(.vertical)
            HStack {
                Text("Already have an account? ")
                Button("SignIn") {
                    dismiss()
                }
            }
            .padding()
        }
        .padding()
        .alert(viewModel.errorMessage, isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {}
        }
    }
    
    @ViewBuilder
    private func passwordField(title: String, value: Binding<String>) -> some View {
        HStack {
            Image(systemName: "lock")
            SecureField(title, text: value)
                .focused($focus, equals: .password)
                .submitLabel(.go)
                .onSubmit {
                    //signInWithEmailPassword()
                }
        }
        .padding(.vertical, 6)
        .background(Divider(), alignment: .bottom)
        .padding(.bottom, 8)
    }
}

extension CreateAccountView {
    private func createAccountWithEmailPassword() {
        Task {
            if await viewModel.createAccountWithEmailPassword() == true {
                AppRootManager.manager.currentRoot = .home
            }
            else {
                showErrorAlert.toggle()
            }
        }
    }
}

#Preview {
    CreateAccountView()
}
