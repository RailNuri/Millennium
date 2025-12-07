//
//  BudgetSelectionView.swift
//  Millenium
//
//  Created by Rail Nuriyev  on 12/6/25.
//


import SwiftUI

extension BudgetSelectionView {
    enum PropertyType {
        case house
        case apartment
        
        var description: String {
            switch self {
            case .house: return "House"
            case .apartment: return "Apartment"
            }
        }
    }
}

struct BudgetSelectionView: View {
    @Binding var isRegistrationComplete: Bool
    @Environment(\.dismiss) private var dismiss

    @State private var location = ""
    @State private var propertyType: PropertyType? = nil
    @State private var budget: Double = 0
    
    let maxBudget: Double = 5_000_000
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                  
                    Spacer()
                    Text("Property Details")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                 
                }
                .padding(.horizontal, 24)

                HStack {
                  
                    Spacer()
                    Text("Step 3 of 3")
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
                .frame(height: 44)
                
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(LinearGradient(colors: [.cyan, .blue], startPoint: .leading, endPoint: .trailing))
                        .frame(width:360)
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(height: 4)
                .padding(.horizontal)
                .padding(.bottom)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Location")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            
                            CustomTextFieldinho(icon: "location", placeholder: "Enter location", text: $location)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Property Type")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 12) {
                                PropertyTypeButton(
                                    icon: "house.fill",
                                    title: "House",
                                    isSelected: propertyType == .house
                                ) {
                                    propertyType = .house
                                }
                                
                                PropertyTypeButton(
                                    icon: "building.2.fill",
                                    title: "Apartment",
                                    isSelected: propertyType == .apartment
                                ) {
                                    propertyType = .apartment
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Budget")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            
                            VStack(spacing: 20) {
                                HStack {
                                    Spacer()
                                    Text(formatCurrency(budget))
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding(.vertical, 20)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(16)
                                
                                VStack(spacing: 12) {
                                    Slider(value: $budget, in: 0...maxBudget, step: 10000)
                                        .accentColor(.white)
                                    
                                    HStack {
                                        Text("0 AZN")
                                            .font(.system(size: 13))
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text("5,000,000 AZN")
                                            .font(.system(size: 13))
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding(.horizontal, 4)
                                
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                    QuickAmountButton(amount: 100_000, budget: $budget)
                                    QuickAmountButton(amount: 500_000, budget: $budget)
                                    QuickAmountButton(amount: 1_000_000, budget: $budget)
                                    QuickAmountButton(amount: 2_000_000, budget: $budget)
                                    QuickAmountButton(amount: 3_000_000, budget: $budget)
                                    QuickAmountButton(amount: 5_000_000, budget: $budget)
                                }
                            }
                        }
                        
                        Button(action: {
                            print("Location: \(location)")
                            print("Property Type: \(propertyType?.description ?? "None")")
                            print("Budget: \(budget)")
                            isRegistrationComplete = true

                        }) {
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
                }
            }
        }
    }
    
    func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 0
        
        if let formatted = formatter.string(from: NSNumber(value: value)) {
            return "\(formatted) AZN"
        }
        return "\(Int(value)) AZN"
    }
}

struct PropertyTypeButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(title)
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundColor(isSelected ? .black : .white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(isSelected ? Color.white : Color.white.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

struct QuickAmountButton: View {
    let amount: Double
    @Binding var budget: Double
    
    var body: some View {
        Button(action: {
            budget = amount
        }) {
            Text(shortFormat(amount))
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(budget == amount ? .black : .white)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(budget == amount ? Color.white : Color.white.opacity(0.1))
                .cornerRadius(10)
        }
    }
    
    func shortFormat(_ value: Double) -> String {
        if value >= 1_000_000 {
            return String(format: "%.0fM", value / 1_000_000)
        } else if value >= 1_000 {
            return String(format: "%.0fK", value / 1_000)
        }
        return "\(Int(value))"
    }
}

struct CustomTextFieldinho: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
            
            TextField(placeholder, text: $text)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        BudgetSelectionView(isRegistrationComplete: .constant(false))
    }
}
