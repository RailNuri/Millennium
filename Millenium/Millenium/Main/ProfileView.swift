//
//  ProfileView.swift
//  Millenium
//
//  Created by Rail Nuriyev  on 12/7/25.
//


import SwiftUI

struct ProfileView: View {
    @State private var name = " Rail Nuriyev"
    @State private var email = "railnuri@millenium.com"
    @State private var phone = "+99477 5004088"
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Text(name.prefix(1))
                                    .font(.system(size: 36, weight: .semibold))
                                    .foregroundColor(.white)
                            )
                        
                        VStack(spacing: 4) {
                            Text(name)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(email)
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 32)
                    
                    VStack(spacing: 24) {
                        SettingsSection(title: "Account") {
                            SettingsRow(icon: "person.fill", title: "Edit Profile", showChevron: true) {}
                            SettingsRow(icon: "heart.fill", title: "Saved Properties", showChevron: true) {}
                            SettingsRow(icon: "clock.fill", title: "Search History", showChevron: true) {}
                        }
                        
                        SettingsSection(title: "Preferences") {
                            SettingsRow(icon: "bell.fill", title: "Notifications", showChevron: true) {}
                            SettingsRow(icon: "globe", title: "Language", subtitle: "English", showChevron: true) {}
                            SettingsRow(icon: "dollarsign.circle.fill", title: "Currency", subtitle: "AZN", showChevron: true) {}
                        }
                        
                        SettingsSection(title: "Support") {
                            SettingsRow(icon: "questionmark.circle.fill", title: "Help Center", showChevron: true) {}
                            SettingsRow(icon: "envelope.fill", title: "Contact Us", showChevron: true) {}
                            SettingsRow(icon: "star.fill", title: "Rate App", showChevron: true) {}
                        }
                        
                        SettingsSection(title: "Legal") {
                            SettingsRow(icon: "doc.text.fill", title: "Terms of Service", showChevron: true) {}
                            SettingsRow(icon: "shield.fill", title: "Privacy Policy", showChevron: true) {}
                        }
                        
                        Button(action: {
                            print("Logout")
                        }) {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .font(.system(size: 18))
                                Text("Log Out")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(12)
                        }
                        .padding(.top, 8)
                        
                        // App Version
                        Text("Version 1.0.0")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                            .padding(.top, 16)
                            .padding(.bottom, 32)
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.gray)
                .textCase(.uppercase)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                content
            }
            .background(Color.white.opacity(0.05))
            .cornerRadius(12)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    var subtitle: String? = nil
    var showChevron: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .frame(width: 24)
                
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                
                Spacer()
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
                
                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .background(
            Rectangle()
                .fill(Color.white.opacity(0.0001))
        )
    }
}

#Preview {
    ProfileView()
}
