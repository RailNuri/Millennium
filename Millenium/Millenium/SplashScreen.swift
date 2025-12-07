//
//  SplashScreen.swift
//  Millenium
//
//  Created by Rail Nuriyev  on 12/7/25.
//


import SwiftUI

struct SplashScreen: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            Image("millennium")
                .resizable()
                .scaledToFit()
                .padding(40)
                .scaleEffect(scale)
                .opacity(opacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                scale = 1.0
            }
            withAnimation(.easeIn(duration: 0.6)) {
                opacity = 1.0
            }
        }
    }
}

#Preview {
    SplashScreen()
}