//
//  MainTabBarView.swift
//  Millenium
//
//  Created by Rail Nuriyev  on 6/12/25.
//


import SwiftUI

struct MainTabBarView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case 0:
                    MapSearchView()
                case 1:
                    BestAreasView()
                case 2:
                    SavedHomesView()
                case 3:
                    ProfileView()
                default:
                    MapSearchView()
                }
            }
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .ignoresSafeArea()
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack {
            TabBarButton(
                icon: "house.fill",
                title: "Home",
                isSelected: selectedTab == 0
            ) {
                selectedTab = 0
            }
            
            TabBarButton(
                icon: "map.fill",
                title: "Search",
                isSelected: selectedTab == 1
            ) {
                selectedTab = 1
            }
            
            TabBarButton(
                icon: "heart.fill",
                title: "Saved",
                isSelected: selectedTab == 2
            ) {
                selectedTab = 2
            }
            
            TabBarButton(
                icon: "person.fill",
                title: "Profile",
                isSelected: selectedTab == 3
            ) {
                selectedTab = 3
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            Color(white: 0.1)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: -5)
        )
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                Text(title)
                    .font(.system(size: 11))
            }
            .foregroundColor(isSelected ? .white : .gray)
            .frame(maxWidth: .infinity)
        }
    }
}

struct SearchPlaceholderView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text("Search View")
                .font(.largeTitle)
                .foregroundColor(.white)
        }
    }
}

struct ProfilePlaceholderView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text("Profile View")
                .font(.largeTitle)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    MainTabBarView()
}
