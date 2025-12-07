//
//  AmenitiesSelectionView.swift
//  Millenium
//
//  Created by Rail Nuriyev  on 12/6/25.
//

import SwiftUI

struct AmenitiesSelectionView: View {
    @Binding var isRegistrationComplete: Bool
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedAmenities: Set<String> = ["Public Transport", "Green Spaces", "Shops & Restaurants"]
    
    let amenities = [
        Amenity(id: "schools", icon: "graduationcap.fill", title: "Near Schools", color: .blue),
        Amenity(id: "hospitals", icon: "cross.case.fill", title: "Near Hospitals", color: .pink),
        Amenity(id: "transport", icon: "bus.fill", title: "Public Transport", color: .cyan),
        Amenity(id: "noise", icon: "speaker.wave.2.fill", title: "Low Noise Area", color: .purple),
        Amenity(id: "green", icon: "tree.fill", title: "Green Spaces", color: .green),
        Amenity(id: "crime", icon: "shield.fill", title: "Low Crime Area", color: .orange),
        Amenity(id: "shops", icon: "cart.fill", title: "Shops & Restaurants", color: .pink),
        Amenity(id: "pet", icon: "pawprint.fill", title: "Pet Friendly", color: .yellow),
    ]
    
    var body: some View {
        GeometryReader { geometry in
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                HStack {
                    
                    Spacer()
                    Text("Your needs")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                  
                }
                .padding(.horizontal, 24)
                
                
                HStack {
                  
                    Spacer()
                    Text("Step 2 of 3")
                        .foregroundColor(.gray)
                    Spacer()
                   
                }
                .padding(.horizontal)
                .padding(.top)
                .frame(height: 44)
                
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(LinearGradient(colors: [.cyan, .blue], startPoint: .leading, endPoint: .trailing))
                        .frame(width: geometry.size.width * 0.6)
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(height: 4)
                .padding(.horizontal)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tell Us What You Need")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Select the amenities and features that matter most to you")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 20)
                        
                        ForEach(0..<4) { row in
                            HStack(spacing: 16) {
                                ForEach(0..<2) { col in
                                    let index = row * 2 + col
                                    if index < amenities.count {
                                        let amenity = amenities[index]
                                        AmenityCard(
                                            amenity: amenity,
                                            isSelected: selectedAmenities.contains(amenity.title)
                                        ) {
                                            if selectedAmenities.contains(amenity.title) {
                                                selectedAmenities.remove(amenity.title)
                                            } else {
                                                selectedAmenities.insert(amenity.title)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 150)
                }
                
                VStack(spacing: 12) {
                    HStack {
                        Text("\(selectedAmenities.count) selected")
                            .foregroundColor(.gray)
                        Spacer()
                        Button("Clear all") {
                            selectedAmenities.removeAll()
                        }
                        .foregroundColor(.cyan)
                    }
                    
                    NavigationLink(destination: BudgetSelectionView(isRegistrationComplete: $isRegistrationComplete)) {
                        HStack {
                            Text("Continue")
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(.white)
                        .cornerRadius(16)
                    }
                }
                .padding()
                .background(Color.black)
            }
        }
    }
}

struct Amenity: Identifiable {
    let id: String
    let icon: String
    let title: String
    let color: Color
}

struct AmenityCard: View {
    let amenity: Amenity
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(amenity.color.opacity(0.2))
                    .frame(width: 64, height: 64)
                    .overlay(
                        Image(systemName: amenity.icon)
                            .font(.system(size: 28))
                            .foregroundColor(amenity.color)
                    )
                
                Text(amenity.title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .background(Color.white.opacity(0.05))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.cyan : Color.clear, lineWidth: 2)
            )
        }
    }
}

#Preview {
    NavigationStack {
        AmenitiesSelectionView(isRegistrationComplete: .constant(false))
    }
}
