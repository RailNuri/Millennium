//
//  PropertyPreferencesView.swift
//  Millenium
//
//  Created by Rail Nuriyev  on 12/7/25.
//


import SwiftUI

struct PropertyPreferencesView: View {
    @Binding var isRegistrationComplete: Bool
    @Environment(\.dismiss) private var dismiss

    @State private var bedrooms: Int = 1
    @State private var bathrooms: Int = 1
    @State private var hasBalcony = false
    @State private var hasTerrace = false
    @State private var hasParking = false
    @State private var hasGarage = false
    @State private var squareMeters: Double = 50
    @State private var selectedFloor: Int = 1
    
    let maxSquareMeters: Double = 500
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    
                    Spacer()
                    Text("Property Preferences")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                  
                }
                .padding(.horizontal, 24)

                
                HStack {
                  
                    Spacer()
                    Text("Step 1 of 3")
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
                .frame(height: 44)
                
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(LinearGradient(colors: [.cyan, .blue], startPoint: .leading, endPoint: .trailing))
                        .frame(width:55)
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(height: 4)
                .padding(.horizontal)
                .padding(.bottom)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Bedrooms")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            
                            CounterControl(value: $bedrooms, min: 1, max: 10)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Bathrooms")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            
                            CounterControl(value: $bathrooms, min: 1, max: 5)
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Square Meters")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            
                            VStack(spacing: 16) {
                                HStack {
                                    Spacer()
                                    Text("\(Int(squareMeters)) m²")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding(.vertical, 16)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(12)
                                
                                VStack(spacing: 8) {
                                    Slider(value: $squareMeters, in: 20...maxSquareMeters, step: 5)
                                        .accentColor(.white)
                                    
                                    HStack {
                                        Text("20 m²")
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text("500 m²")
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding(.horizontal, 4)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Floor")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            
                            CounterControl(value: $selectedFloor, min: 1, max: 50, suffix: ordinalSuffix(for: selectedFloor))
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Amenities")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            
                            VStack(spacing: 12) {
                                AmenityToggle(icon: "leaf.fill", title: "Balcony", isOn: $hasBalcony)
                                AmenityToggle(icon: "sun.max.fill", title: "Terrace", isOn: $hasTerrace)
                                AmenityToggle(icon: "car.fill", title: "Parking", isOn: $hasParking)
                                AmenityToggle(icon: "building.fill", title: "Garage", isOn: $hasGarage)
                            }
                        }
                        
                        NavigationLink(destination: AmenitiesSelectionView(isRegistrationComplete: $isRegistrationComplete)) {
                            Text("Continue")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                        .padding(.top, 20)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
    }
    
    func ordinalSuffix(for number: Int) -> String {
        let suffix: String
        let ones = number % 10
        let tens = (number % 100) / 10
        
        if tens == 1 {
            suffix = "th"
        } else {
            switch ones {
            case 1: suffix = "st"
            case 2: suffix = "nd"
            case 3: suffix = "rd"
            default: suffix = "th"
            }
        }
        
        return "\(number)\(suffix) floor"
    }
}

struct CounterControl: View {
    @Binding var value: Int
    let min: Int
    let max: Int
    var suffix: String = ""
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: {
                if value > min {
                    value -= 1
                }
            }) {
                Image(systemName: "minus")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(value > min ? .white : .gray)
                    .frame(width: 50, height: 50)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
            }
            .disabled(value <= min)
            
            Text(suffix.isEmpty ? "\(value)" : suffix)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
            
            Button(action: {
                if value < max {
                    value += 1
                }
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(value < max ? .white : .gray)
                    .frame(width: 50, height: 50)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
            }
            .disabled(value >= max)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

struct AmenityToggle: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        Button(action: {
            isOn.toggle()
        }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isOn ? .black : .white)
                    .frame(width: 44, height: 44)
                    .background(isOn ? Color.white : Color.white.opacity(0.1))
                    .cornerRadius(10)
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: isOn ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(isOn ? .white : .gray)
            }
            .padding(16)
            .background(Color.white.opacity(isOn ? 0.1 : 0.05))
            .cornerRadius(12)
        }
    }
}

#Preview {
    NavigationStack {
        PropertyPreferencesView(isRegistrationComplete: .constant(false))
    }
}
