//
//  SecurePersistenceView.swift
//  SecretApp
//
//  Created by Carlos Xavier Carvajal Villegas on 13/5/25.
//

import SwiftUI
import SwiftData

struct SecurePersistenceView: View {
    @Environment(\.modelContext) private var context
    @State private var vm = SecurePersistenceVM()
    
    @State private var newName = ""
    @State private var newCardNumber = ""

    @State private var showInsert = false
    @Query private var clients: [ClientsDB]


    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showInsert.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    
                }
                if vm.clients.count > 0 {
                    List {
                        ForEach(vm.clients) { client in
                            VStack(alignment: .leading){
                                Text(client.name)
                                Text(client.cardNumber)
                            }
                        }
                    }
                    .frame(height: 300)
                    .listStyle(.plain)
                } else {
                    ContentUnavailableView("There are no clients yet.", systemImage: "person.fill", description: Text("Add new clients by tapping the plus button in the top right corner."))
                }
                if clients.count > 0 {
                    List {
                        ForEach(clients) { client in
                            VStack(alignment: .leading) {
                                Text(client.name)
                                Text(client.cardNumber)
                            }
                        }
                    }
                    .frame(height: 300)
                    .listStyle(.plain)
                } else {
                    ContentUnavailableView("There are no clients on the data base",
                                           systemImage: "person.fill",
                                           description: Text("Add new clients by tapping the plus button in the top right corner."))
                }
            }
        }
        .overlay {
            formData
                .opacity(showInsert ? 1.0 : 0.0)
                .offset(y: showInsert ? 0 : 300)
        }
        .safeAreaPadding()
        .animation(.default, value: showInsert)
    }
    
    var formData: some View {
        VStack {
            TextField("Introduzca el nombre", text: $newName)
                .textContentType(.name)
            TextField("Introduzca la tarjeta", text: $newCardNumber)
                .textContentType(.creditCardNumber)
            HStack {
                Button {
                    showInsert.toggle()
                } label: {
                    Text("Cancelar")
                }
                Button {
                    vm.addClient(name: newName, cardNumber: newCardNumber)
                    showInsert.toggle()
                } label: {
                    Text("Añadir JSON")
                }
                Button {
                    vm.addClientDB(name: newName, cardNumber: newCardNumber, context: context)
                    showInsert.toggle()
                } label: {
                    Text("Añadir BBDD")
                }
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .textFieldStyle(.roundedBorder)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGroupedBackground))
        }
    }
}

#Preview {
    SecurePersistenceView()
}
