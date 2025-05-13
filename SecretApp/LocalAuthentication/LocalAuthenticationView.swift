//
//  LocalAuthenticationView.swift
//  SecretApp
//
//  Created by Carlos Xavier Carvajal Villegas on 12/5/25.
//

import SwiftUI

struct LocalAuthenticationView: View {
    @State private var vm = LocalAuthVM()
    
    var body: some View {
        VStack {
            Image(.spiderMan)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()
        }
        .overlay {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
                .overlay {
                    VStack {
                        Button {
                            Task {
                                try? await vm.checkBiometry()
                            }
                        } label: {
                            switch vm.biometry {
                            case .faceID:
                                Image(systemName: "faceid")
                            case .touchID:
                                Image(systemName: "touchid")
                            case .opticID:
                                Image(systemName: "opticid")
                            case .none:
                                Image(systemName: "exclamationmark.triangle.fill")
                            }
                        }
                        .font(.largeTitle)
                        .buttonStyle(.bordered)
                        .padding()

                        Image(systemName: "lock")
                            .font(.largeTitle)
                            .symbolVariant(.fill)
                            .offset(y: vm.accessGranted ? 300 : 0)
                    }
                }
                .opacity(vm.accessGranted ? 0.0 : 1.0)
        }
        .animation(.default, value: vm.accessGranted)
    }
}

#Preview {
    LocalAuthenticationView()
}
