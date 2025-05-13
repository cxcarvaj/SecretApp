//
//  CifradoVM.swift
//  SecretApp
//
//  Created by Carlos Xavier Carvajal Villegas on 11/5/25.
//

import SwiftUI

enum EncryptType: String, CaseIterable, Identifiable {
    case GCM = "AES-GCM"
    case ChaCha = "Chacha20/Poly1305"
    case signing = "Signing"
    var id: Self { self }
}

@Observable
final class CifradoVM {
    let secureKeyManager = SecureKeyManager.shared
    
    var text = ""
    var encryptedText = ""
    var decryptedText = ""
    
    var encryptType: EncryptType = .GCM
    
    func encrypt() throws {
        switch encryptType {
        case .GCM:
            encryptedText = try secureKeyManager
                .GCMEncrypt(data: Data(text.utf8))?
                .base64EncodedString() ?? "Error encrypting data"
        case .ChaCha:
            encryptedText = try secureKeyManager
                .ChaChaEncrypt(data: Data(text.utf8))
                .base64EncodedString()
        case .signing:
            encryptedText = try secureKeyManager
                .sign(data: text)
                .base64EncodedString()
        }
    }
    
    func decrypt() throws {
        switch encryptType {
        case .GCM:
            if let data = Data(base64Encoded: encryptedText),
               let text = try secureKeyManager.GCMDecryptString(data: data) {
                decryptedText = text
            } else {
                decryptedText = "Error decrypting data"
            }
        case .ChaCha:
            if let data = Data(base64Encoded: encryptedText),
               let text = try secureKeyManager.ChaChaDecryptString(data: data) {
                decryptedText = text
            } else {
                decryptedText = "Error decrypting data"
            }
        case .signing:
            if let signature = Data(base64Encoded: encryptedText) {
                if try secureKeyManager
                    .validateSignature(dataString: text, signature: signature) {
                    decryptedText = "Signature validated."
                } else {
                    decryptedText = "Signature not validated."
                }
            }
        }
    }
}
