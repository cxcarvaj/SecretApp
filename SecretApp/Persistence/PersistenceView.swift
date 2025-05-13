//
//  PersistenceView.swift
//  SecretApp
//
//  Created by Carlos Xavier Carvajal Villegas on 11/5/25.
//

import SwiftUI

struct PersistenceView: View {
    @State private var vm = PersistenceVM()
    
    var body: some View {
        Form {
            Section {
                TextField("Enter the text to save", text: $vm.text, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
                TextField("Enter the key to identify the data", text: $vm.key)
                    .textCase(.lowercase)
                    .textInputAutocapitalization(.never)
                Picker("Persistence Type", selection: $vm.persistenceType) {
                    ForEach(PersistenceType.allCases) { type in
                            Text(type.rawValue)
                            .tag(type)
                    }
                }
                Button {
                    try? vm.save()
                } label: {
                    Text("Save data")
                }
                .frame(maxWidth: .infinity)

            } header: {
                Text("Persistence")
            }
            
            Section {
                Text(vm.retrievedText)
                    .frame(maxWidth: .infinity, minHeight: 100)
                    .lineLimit(3, reservesSpace: true)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .fill(.black.opacity(0.3))
                    }
                
                Button {
                    try? vm.load()
                } label: {
                    Text("Load data")
                }
                .frame(maxWidth: .infinity)

            }
        }
        .textFieldStyle(.roundedBorder)
        .buttonStyle(.bordered)
    }
}

#Preview {
    PersistenceView()
}
