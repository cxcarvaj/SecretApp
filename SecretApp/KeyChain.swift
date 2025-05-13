//
//  KeyChain.swift
//  SecretApp
//
//  Created by Carlos Xavier Carvajal Villegas on 9/5/25.
//

import Foundation

@propertyWrapper
struct KeyChain {
    let key: String
    
    init(key: String) {
        self.key = key
    }
    
    var wrappedValue: Data? {
        get {
//            UserDefaults.standard.string(forKey: key)
            SecKeyStore.shared.readValue(withLabel: key)
        } set {
//            UserDefaults.standard.set(newValue, forKey: key)
            if let value = newValue {
                SecKeyStore.shared.storeValue(value, withLabel: key)
            } else {
                SecKeyStore.shared.deleteValue(withLabel: key)
            }
        }
    }
}
