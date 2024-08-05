//
//  Login View.swift
//  POC
//
//  Created by chandra sekhar p on 02/08/24.
//

import SwiftUI

private enum FocusableField: Hashable {
    case email
    case password
}

struct LoginView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @FocusState private var focus: FocusableField?
    @ObservedObject var viewModel: LoginViewModel = LoginViewModel()
    
    @State var showErrorAlert = false
    @State var goToHomeScreen = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("login")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 250)
                Text("Login")
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
                
                HStack {
                    Image(systemName: "lock")
                    SecureField("Password", text: $viewModel.password)
                        .focused($focus, equals: .password)
                        .submitLabel(.go)
                        .onSubmit {
                            //signInWithEmailPassword()
                        }
                }
                .padding(.vertical, 6)
                .background(Divider(), alignment: .bottom)
                .padding(.bottom, 8)
                
                Button(action: signInWithEmailPassword) {
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
                .padding(.top)

                HStack {
                    VStack { Divider() }
                    Text("or")
                    VStack { Divider() }
                }
                .padding(.top)
                HStack {
                    Text("Don't have an account?")
                    NavigationLink("Create") {
                        CreateAccountView()
                    }
                }
                .padding()
            }
            .padding()
            .alert(viewModel.errorMessage, isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) {}
            }
            .navigationBarBackButtonHidden()
        }
    }
}

extension LoginView {
    private func signInWithEmailPassword() {
        Task {
            if await viewModel.signInWithEmailPassword() == true {
                AppRootManager.manager.currentRoot = .home
            }
            else {
                showErrorAlert.toggle()
            }
        }
    }
}

#Preview {
    LoginView()
}
