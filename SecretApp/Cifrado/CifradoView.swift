//
//  CifradoView.swift
//  SecretApp
//
//  Created by Carlos Xavier Carvajal Villegas on 11/5/25.
//

import SwiftUI

struct CifradoView: View {
    @State private var vm = CifradoVM()
    @Environment(\.isSceneCaptured) private var isSceneCaptured
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Picker(selection: $vm.encryptType) {
                    ForEach(EncryptType.allCases) { type in
                        Text(type.rawValue)
                            .tag(type)
                    }
                } label: {
                    Text("Select Encryption Type")
                }
                .pickerStyle(.segmented)
                .padding(.bottom)
                
                Text("Text to \(vm.encryptType == .signing ? "sign" : "encrypt")")
                    .font(.headline)
                TextField("Enter the text to \(vm.encryptType == .signing ? "sign" : "encrypt")",
                          text: $vm.text,
                          axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
                
                Button {
                    try? vm.encrypt()
                } label: {
                    Text("\(vm.encryptType == .signing ? "Sign" : "Encrypt")")
                }
                .padding(.bottom)
                
                Text("Text \(vm.encryptType == .signing ? "Signed" : "Encrypted") in base64")
                    .font(.headline)
                Text(vm.encryptedText)
                    .lineLimit(4, reservesSpace: true)
                    .frame(height: 150, alignment: .top)
                    .background {
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(lineWidth: 1)
                            .fill(.black.opacity(0.3))
                    }
                    .privacySensitive()

                Button {
                    try? vm.decrypt()
                } label: {
                    Text("\(vm.encryptType == .signing ? "Verify Sign" : "Decrypt") text")
                }
                .padding(.bottom)
                
                Text("Text \(vm.encryptType == .signing ? "validated" : "decrypted")")
                    .font(.headline)
                Text(vm.decryptedText)
                    .lineLimit(4, reservesSpace: true)
                    .frame(height: 150, alignment: .top)
                    .background {
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(lineWidth: 1)
                            .fill(.black.opacity(0.3))
                    }
                    .privacySensitive()
            }
            .overlay {
                Rectangle()
                    .fill(.background)
                    .overlay {
                        Image(systemName: "lock")
                            .font(.largeTitle)
                            .symbolVariant(.fill)
                    }
                    .opacity(isSceneCaptured ? 1.0 : 0.0)
            }
        }
        .safeAreaPadding()
        .textFieldStyle(.roundedBorder)
        .buttonStyle(.bordered)
    }
}

#Preview {
    CifradoView()
}
