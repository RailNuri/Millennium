//
//  SavedHomesView.swift
//  Millenium
//
//  Created by Rail Nuriyev  on 12/6/25.
//

import SwiftUI

struct SavedHomesView: View {
    @State private var savedHomes = [
        SavedHome(image: "house1", title: "Modern Villa", location: "Beverly Hills, CA", price: "$2,450,000", match: "92%", matchColor: .green),
        SavedHome(image: "house2", title: "Skyline Penthouse", location: "Manhattan, NY", price: "$3,200,000", match: "89%", matchColor: .green),
        SavedHome(image: "house3", title: "Beach House", location: "Malibu, CA", price: "$4,100,000", match: "85%", matchColor: .yellow),
        SavedHome(image: "house4", title: "Family Estate", location: "Palo Alto, CA", price: "$1,850,000", match: "90%", matchColor: .green),
        SavedHome(image: "house5", title: "Downtown Loft", location: "Brooklyn, NY", price: "$1,275,000", match: "82%", matchColor: .yellow),
        SavedHome(image: "house6", title: "Mountain Retreat", location: "Aspen, CO", price: "$2,900,000", match: "88%", matchColor: .green),
        SavedHome(image: "house7", title: "Minimalist Home", location: "Austin, TX", price: "$975,000", match: "79%", matchColor: .yellow),
        SavedHome(image: "house8", title: "Classic Brownstone", location: "Boston, MA", price: "$1,650,000", match: "91%", matchColor: .green),
    ]
    
    var body: some View {
        VStack(spacing: 0) {
         
            VStack(alignment: .leading, spacing: 4) {
                
                HStack{
                    Text("Saved Homes")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                }
                
                Text("\(savedHomes.count) properties saved")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(savedHomes) { home in
                        SavedHomeCard(home: home)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
            
            Spacer()
        }
        .background(Color.black.ignoresSafeArea())
        .overlay(
            VStack {
                Spacer()
                HStack {
                    NavButton(icon: "house", label: "Home", isActive: false)
                    NavButton(icon: "magnifyingglass", label: "Search", isActive: false)
                    NavButton(icon: "heart.fill", label: "Saved", isActive: true)
                    NavButton(icon: "person", label: "Profile", isActive: false)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color(white: 0.1))
            }
        )
    }
}

struct SavedHome: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let location: String
    let price: String
    let match: String
    let matchColor: Color
}

struct SavedHomeCard: View {
    let home: SavedHome
    @State private var isFavorite = true
    
    var body: some View {
        HStack(spacing: 12) {
            Image(home.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(home.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                    Text(home.location)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                
                HStack(spacing: 8) {
                    Text(home.price)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("\(home.match) Match")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(home.matchColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(home.matchColor.opacity(0.2))
                        .cornerRadius(6)
                }
            }
            
            Spacer()
            
            Button(action: {
                isFavorite.toggle()
            }) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .pink : .gray)
                    .font(.system(size: 20))
            }
        }
        .padding(12)
        .background(Color(white: 0.1))
        .cornerRadius(12)
    }
}

struct NavButton: View {
    let icon: String
    let label: String
    let isActive: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
            Text(label)
                .font(.system(size: 11))
        }
        .foregroundColor(isActive ? .white : .gray)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SavedHomesView()
}
