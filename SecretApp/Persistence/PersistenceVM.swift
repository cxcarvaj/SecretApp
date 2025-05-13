//
//  PersistenceVM.swift
//  SecretApp
//
//  Created by Carlos Xavier Carvajal Villegas on 11/5/25.
//
import SwiftUI

enum PersistenceType: String, CaseIterable, Identifiable {
    case propertyList = "Property Lists"
    case json = "JSON"
    case documents = "Documents"
    case userDefaults = "User Defaults"
    case keychain = "Keychain"
    
    var id: Self { self }
}

struct Persistence: Codable {
    var text: String
}


@Observable
final class PersistenceVM {
    var text = ""
    var retrievedText = ""
    var key = ""
    
    var persistenceType: PersistenceType = .propertyList
    
    var plistEncoder: PropertyListEncoder {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        return encoder
    }
    
    func save() throws {
        switch persistenceType {
        case .propertyList:
            let persistence = Persistence(text: text)
            let data = try plistEncoder.encode(persistence)
            try data.write(to: .documentsDirectory.appending(path: "datos.plist"), options: [.atomic, .completeFileProtection])
            
        case .json:
            let persistence = Persistence(text: text)
            let data = try JSONEncoder().encode(persistence)
            try data.write(to: .documentsDirectory.appending(path: "datos.json"), options: [.atomic, .completeFileProtection])
            
        case .documents:
            try text.write(to: .documentsDirectory.appending(path: "datos.txt"), atomically: true, encoding: .utf8)
            
        case .userDefaults:
            UserDefaults.standard.set(text, forKey: key)
    
        case .keychain:
            SecKeyStore.shared.storeValue(Data(text.utf8), withLabel: key)
        
        }
    }
    
    func load() throws {
        switch persistenceType {
        case .propertyList:
            let data = try Data(contentsOf: .documentsDirectory.appending(path: "datos.plist"))
            retrievedText = try PropertyListDecoder().decode(Persistence.self, from: data).text
            
        case .json:
            let data = try Data(contentsOf: .documentsDirectory.appending(path: "datos.json"))
            retrievedText = try JSONDecoder().decode(Persistence.self, from: data).text
            
        case .documents:
            let data = try Data(contentsOf: .documentsDirectory.appending(path: "datos.txt"))
            retrievedText = String(data: data, encoding: .utf8) ?? "Error trying to retrieve data"
            
        case .userDefaults:
            retrievedText = UserDefaults.standard.string(forKey: key) ?? "Error trying to retrieve data. The key \(key) does not exist"
            
        case .keychain:
            if let data = SecKeyStore.shared.readValue(withLabel: key),
               let text = String(data: data, encoding: .utf8) {
                retrievedText = text
            }
        }
    }
}

