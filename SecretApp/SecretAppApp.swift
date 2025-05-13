//
//  SecretAppApp.swift
//  SecretApp
//
//  Created by Carlos Xavier Carvajal Villegas on 9/5/25.
//

import SwiftUI
import SwiftData

@main
struct SecretAppApp: App {
    @Environment(\.scenePhase) var phase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    print(URL.documentsDirectory)
                }
                .overlay {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .overlay {
                            Image(systemName: "lock")
                                .font(.largeTitle)
                                .symbolVariant(.fill)
                                .offset(y: phase != .active ? 0: 300)
                        }
                        .opacity(phase != .active ? 1.0 : 0.0)
                }
                .animation(.default, value: phase)
        }
        .modelContainer(for: ClientsDB.self)
    }
}
