//
//  MilleniumApp.swift
//  Millenium
//
//  Created by Rail Nuriyev  on 12/6/25.
//

import SwiftUI
import CoreData

@main
struct MilleniumApp: App {
    let persistenceController = PersistenceController.shared
    @State private var isRegistrationComplete = false
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashScreen()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation {
                                showSplash = false
                            }
                        }
                    }
            } else if isRegistrationComplete {
                MainTabBarView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                NavigationStack {
                    RegistrationView(isRegistrationComplete: $isRegistrationComplete)
                        .navigationBarHidden(true)
                }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
