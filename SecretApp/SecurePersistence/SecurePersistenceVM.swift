//
//  SecurePersistenceVM.swift
//  SecretApp
//
//  Created by Carlos Xavier Carvajal Villegas on 13/5/25.
//

import SwiftUI
import SwiftData

struct Client: Codable, Identifiable {
    let id: UUID
    let name: String
    let cardNumber: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case cardNumber
    }
    
    init(id: UUID = UUID(), name: String, cardNumber: String) {
        self.id = id
        self.name = name
        self.cardNumber = cardNumber
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        let cardNumber = try container.decode(String.self, forKey: .cardNumber)
        self.cardNumber = try SecureKeyManager.shared.ChaChaDecryptB64(data: cardNumber) ?? "Valor no recuperado"
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        let cardNumber = try SecureKeyManager.shared.ChaChaEncryptB64(data: Data(self.cardNumber.utf8))
        try container.encode(cardNumber, forKey: .cardNumber)
    }
}

func getClients() throws -> [Client] {
    let url = URL.documentsDirectory.appendingPathComponent("clients.json")
    let data = try Data(contentsOf: url)
    return try JSONDecoder().decode([Client].self, from: data)
}

func saveClients(_ clients: [Client]) throws {
    let url = URL.documentsDirectory.appendingPathComponent("clients.json")
    let data = try JSONEncoder().encode(clients)
    try data.write(to: url, options: .atomic)
}

func getClientsSecure() throws -> [Client] {
    let url = URL.documentsDirectory.appendingPathComponent("clientes.data")
    let secureData = try Data(contentsOf: url)
    let data = try SecureKeyManager.shared.ChaChaDecrypt(data: secureData)
    return try JSONDecoder().decode([Client].self, from: data)
}

func saveClientsSecure(_ clients: [Client]) throws {
    let url = URL.documentsDirectory.appendingPathComponent("clientes.data")
    let json = try JSONEncoder().encode(clients)
    let secureData = try SecureKeyManager.shared.ChaChaEncrypt(data: json)
    try secureData.write(to: url, options: .atomic)
}

@Observable
final class SecurePersistenceVM {
    var clients: [Client] {
        didSet {
            try? saveClientsSecure(clients)
        }
    }
    
    init() {
        do {
            clients = try getClientsSecure()
        } catch {
            clients = []
        }
    }
    
    func addClient(name: String, cardNumber: String) {
        guard !name.isEmpty, !cardNumber.isEmpty else { return }
        let newClient = Client(id: UUID(), name: name, cardNumber: cardNumber)
        clients.append(newClient)
    }
    
    func addClientDB(name: String, cardNumber: String, context: ModelContext) {
        guard !name.isEmpty, !cardNumber.isEmpty else { return }
        let newClient = ClientsDB(name: name, cardNumber: cardNumber)
        context.insert(newClient)
    }
    
}
