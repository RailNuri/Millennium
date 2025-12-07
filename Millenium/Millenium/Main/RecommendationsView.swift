//
//  RecommendationsView.swift
//  Millenium
//
//  Created by Rail Nuriyev  on 12/7/25.
//


import SwiftUI

struct RecommendationsView: View {
    @State private var selectedFilter: RecommendationFilter = .all
    
    let recommendations = [
        Recommendation(
            title: "Greenery Level (NDVI)",
            subtitle: "Vegetation & green spaces",
            value: "High",
            percentage: 85,
            icon: "leaf.fill",
            color: .green,
            description: "Areas with abundant parks and tree coverage"
        ),
        Recommendation(
            title: "Build-up Density",
            subtitle: "Urban development intensity",
            value: "Moderate",
            percentage: 62,
            icon: "building.2.fill",
            color: .orange,
            description: "Balanced urban environment with good spacing"
        ),
        Recommendation(
            title: "Night Time Activity",
            subtitle: "Evening vibrancy & safety",
            value: "High",
            percentage: 78,
            icon: "moon.stars.fill",
            color: .purple,
            description: "Well-lit areas with active nightlife and amenities"
        ),
        Recommendation(
            title: "15-Min Walkable Areas",
            subtitle: "Accessibility to essentials",
            value: "Excellent",
            percentage: 92,
            icon: "figure.walk",
            color: .blue,
            description: "Everything you need within walking distance"
        )
    ]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: 12) {
                     
                        
                        Text("What We Recommend")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Based on your lifestyle preferences")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                    
                    // Overall Match Score
                    VStack(spacing: 16) {
                        Text("Overall Match")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        ZStack {
                            Circle()
                                .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                                .frame(width: 180, height: 180)
                            
                            Circle()
                                .trim(from: 0, to: 0.87)
                                .stroke(
                                    LinearGradient(
                                        colors: [.green, .cyan],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    style: StrokeStyle(lineWidth: 20, lineCap: .round)
                                )
                                .frame(width: 180, height: 180)
                                .rotationEffect(.degrees(-90))
                            
                            VStack(spacing: 4) {
                                Text("87%")
                                    .font(.system(size: 56, weight: .bold))
                                    .foregroundColor(.white)
                                Text("Match")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                    
                    VStack(spacing: 16) {
                        ForEach(recommendations) { recommendation in
                            RecommendationCard(recommendation: recommendation)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            
            VStack {
                Spacer()
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "map.fill")
                        Text("View on Map")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        LinearGradient(
                            colors: [.green, .cyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
                .background(
                    LinearGradient(
                        colors: [Color.black.opacity(0), Color.black],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 150)
                    .offset(y: 30)
                )
            }
        }
    }
}

struct Recommendation: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let value: String
    let percentage: Int
    let icon: String
    let color: Color
    let description: String
}

struct RecommendationCard: View {
    let recommendation: Recommendation
    @State private var showDetails = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(recommendation.color.opacity(0.2))
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: recommendation.icon)
                        .font(.system(size: 24))
                        .foregroundColor(recommendation.color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(recommendation.title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(recommendation.subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text(recommendation.value)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(recommendation.color)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(recommendation.color.opacity(0.2))
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("\(recommendation.percentage)%")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.3)) {
                            showDetails.toggle()
                        }
                    }) {
                        Image(systemName: showDetails ? "chevron.up.circle.fill" : "info.circle.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 18))
                    }
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(recommendation.color)
                            .frame(width: geometry.size.width * CGFloat(recommendation.percentage) / 100, height: 8)
                    }
                }
                .frame(height: 8)
            }
            
            if showDetails {
                Text(recommendation.description)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .padding(.top, 4)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(20)
        .background(Color(white: 0.1))
        .cornerRadius(16)
    }
}

enum RecommendationFilter {
    case all, high, moderate, low
}

#Preview {
    RecommendationsView()
}
