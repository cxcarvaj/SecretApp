//
//  ClientsDB.swift
//  SecretApp
//
//  Created by Carlos Xavier Carvajal Villegas on 13/5/25.
//

import Foundation
import SwiftData

@Model
final class ClientsDB {
    @Attribute(.unique) var id: UUID
    var name: String
    private var creditCardStorage = Data()
    
    var cardNumber: String {
        get {
            (try? SecureKeyManager.shared.ChaChaDecryptString(data: creditCardStorage)) ?? "Valor no disponible"
        }
        set {
            creditCardStorage = (try? SecureKeyManager.shared.ChaChaEncrypt(data: Data(newValue.utf8))) ?? Data()
        }
    }
    
    init(id: UUID = UUID(), name: String, cardNumber: String) {
        self.id = id
        self.name = name
        self.cardNumber = cardNumber
    }
}
