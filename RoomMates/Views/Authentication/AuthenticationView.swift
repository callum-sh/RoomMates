//
//  AuthenticationView.swift
//  RoomMates
//
//  Created by callum on 2024-10-04.
//

import SwiftUI

struct AuthenticationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoginMode = true
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var authError: String?  // State to store any authentication error

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(spacing: 15) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5)
                }
                .padding(.horizontal)
                
                Picker(selection: $isLoginMode, label: Text("Mode")) {
                    Text("Login").tag(true)
                    Text("Sign Up").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                Button(action: handleAction) {
                    Text(isLoginMode ? "Login" : "Create Account")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(5)
                }
                .padding()

                Button(action: {
                    isLoginMode.toggle()
                }) {
                    Text(isLoginMode ? "Create an account? Sign up." : "Already have an account? Log in.")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .navigationTitle(isLoginMode ? "Login" : "Sign Up")
            .alert(item: $authError) { error in
                Alert(title: Text("Error"), message: Text(error), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func handleAction() {
        if isLoginMode {
            authViewModel.signIn(email: email, password: password) { error in
                if let error = error {
                    self.authError = error
                }
            }
        } else {
            authViewModel.signUp(email: email, password: password) { error in
                if let error = error {
                    self.authError = error
                }
            }
        }
    }
}

extension String: Identifiable {
    public var id: String { self }
}
