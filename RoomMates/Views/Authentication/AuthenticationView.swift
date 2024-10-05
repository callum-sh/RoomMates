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
            ZStack {
                // Background Image
                // heavy inspiration from 
                Image("AuthScreenBanner")
                    .resizable()
                    .scaledToFill() // Make sure the image fills the entire background
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure it covers the entire available space
                    .edgesIgnoringSafeArea(.all) // Extend the background image to cover the entire screen
                
                // Foreground Content (Inputs and Buttons)
                VStack {
                    VStack(spacing: 20) {
                        VStack(spacing: 15) {
                            // Input Section with reduced size
                            VStack(spacing: 15) {
                                TextField("Email", text: $email)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .padding()
                                    .background(Color(.secondarySystemBackground).opacity(0.8))
                                    .cornerRadius(5)
                                    .frame(maxWidth: 300)
                                
                                SecureField("Password", text: $password)
                                    .padding()
                                    .background(Color(.secondarySystemBackground).opacity(0.8))
                                    .cornerRadius(5)
                                    .frame(maxWidth: 300 )
                            }
                            .padding(.horizontal)
                        }
                        
                        
                        // Action Button
                        Button(action: handleAction) {
                            Text(isLoginMode ? "Login" : "Create Account")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: 300) // Reduced width to match input size
                                .background(Color.blue)
                                .cornerRadius(5)
                        }
                        .padding()
                    }
                    Spacer()

                    // Toggle Button between Login and Sign Up
                    Button(action: {
                        isLoginMode.toggle()
                    }) {
                        Text(isLoginMode ? "Create an account? Sign up." : "Already have an account? Log in.")
                            .foregroundColor(.blue)
                    }
                }
                .padding()
            }
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

// TODO: what is this, why do we have it, and why cant we remove it? 
extension String: Identifiable {
    public var id: String { self }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
            .environmentObject(AuthViewModel()) // Ensure to provide the environment object
    }
}
