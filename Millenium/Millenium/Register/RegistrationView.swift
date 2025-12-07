//
//  RegistrationView.swift
//  Millenium
//
//  Created by Rail Nuriyev  on 12/6/25.
//

import SwiftUI

struct RegistrationView: View {
    @Binding var isRegistrationComplete: Bool
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 0) {
                    Spacer()
                    
                    VStack(spacing: 40) {
                        VStack(spacing: 8) {
                            Text("Welcome")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Create your account")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                        }
                        
                        VStack(spacing: 20) {
                            CustomTextField(icon: "person", placeholder: "Name", text: $name)
                            CustomTextField(icon: "envelope", placeholder: "Email", text: $email)
                            CustomTextField(icon: "lock", placeholder: "Password", text: $password, isSecure: true)
                        }
                        
                        NavigationLink(destination: PropertyPreferencesView(isRegistrationComplete: $isRegistrationComplete)) {
                            Text("Sign Up")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                        .padding(.top, 10)
                        
                        HStack(spacing: 4) {
                            Text("Already have an account?")
                                .foregroundColor(.gray)
                            Button(action: {}) {
                                Text("Sign In")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                            }
                        }
                        .font(.system(size: 15))
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                    Spacer()
                }
            }
                
              
            }
            .navigationBarHidden(true)
        }
    }

struct CustomTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    @State private var isShowingPassword = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
            
            if isSecure && !isShowingPassword {
                SecureField(placeholder, text: $text)
                    .foregroundColor(.white)
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder)
                            .foregroundColor(.gray.opacity(0.6))
                    }
            } else {
                TextField(placeholder, text: $text)
                    .foregroundColor(.white)
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder)
                            .foregroundColor(.gray.opacity(0.6))
                    }
            }
            
            if isSecure {
                Button(action: {
                    isShowingPassword.toggle()
                }) {
                    Image(systemName: isShowingPassword ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview {
    NavigationStack {
        RegistrationView(isRegistrationComplete: .constant(false))
    }
}
