//
//  ContentView.swift
//  SecretApp
//
//  Created by Carlos Xavier Carvajal Villegas on 9/5/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Secure Storage",
                systemImage: "lock.document") {
                SecurePersistenceView()
            }
            
            Tab("Authentication", systemImage: "lock.iphone") {
                LocalAuthenticationView()
            }
            Tab("Encryption",
                systemImage: "lock.fill") {
                CifradoView()
            }
            Tab("Persistence", systemImage: "square.and.arrow.down") {
                PersistenceView()
            }
        }
    }
}

#Preview {
    ContentView()
}
