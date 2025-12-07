//
//  HouseDetailsView.swift
//  Millenium
//
//  Created by Rail Nuriyev  on 12/6/25.
//

import SwiftUI

struct HouseDetailsView: View {
    @State private var isSaved = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                
                
                Spacer()
                
                Text("House Details")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.leading,40)
                
                Spacer()
                
                Button(action: { isSaved.toggle() }) {
                    Image(systemName: isSaved ? "heart.fill" : "heart")
                        .foregroundColor(isSaved ? .pink : .white)
                        .font(.system(size: 20))
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            
            ScrollView {
                VStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 250)
                        .overlay(
                            Image("house1")
                                .resizable()
                                .cornerRadius(20)
                                .font(.system(size: 80))
                                .foregroundColor(.gray)
                        )
                        .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("₼ 350,000")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Modern Family Home")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    HStack(spacing: 12) {
                        PropertyInfoCard(icon: "bed.double.fill", value: "4", label: "Bedrooms")
                        PropertyInfoCard(icon: "bathtub.fill", value: "3", label: "Bathrooms")
                        PropertyInfoCard(icon: "square.grid.2x2", value: "2,400", label: "Sq ft")
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Area Match Score")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("92%")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.green)
                                .cornerRadius(8)
                        }
                        
                        VStack(spacing: 12) {
                            MatchItem(text: "Near excellent schools")
                            MatchItem(text: "Close to hospital")
                            MatchItem(text: "Safe neighborhood")
                            MatchItem(text: "Good public transport")
                            MatchItem(text: "Shopping centers nearby")
                        }
                    }
                    .padding(20)
                    .background(Color(white: 0.1))
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Location")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(white: 0.15))
                            .frame(height: 180)
                            .overlay(
                                VStack {
                                    Image(systemName: "map.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.gray)
                                    
                                    ZStack {
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 30, height: 30)
                                        
                                        Image(systemName: "mappin.circle.fill")
                                            .foregroundColor(.white)
                                            .font(.system(size: 24))
                                    }
                                    .offset(y: 10)
                                }
                            )
                        
                        HStack(spacing: 6) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            
                            Text("1247 Maple Street, Downtown District")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
            
            Spacer()
        }
        .background(Color.black.ignoresSafeArea())
        .overlay(
            VStack {
                Spacer()
                
                HStack(spacing: 12) {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "bookmark")
                            Text("Save Home")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color(white: 0.15))
                        .cornerRadius(16)
                    }
                    
                    NavigationLink(destination: RecommendationsView()) {
                        HStack {
                            Text("Learn more")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.blue)
                        .cornerRadius(16)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        )
    }
}

struct PropertyInfoCard: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.blue)
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(white: 0.1))
        .cornerRadius(12)
    }
}

struct MatchItem: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color.green)
                .frame(width: 8, height: 8)
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.white)
            
            Spacer()
        }
    }
}

#Preview {
    HouseDetailsView()
}
