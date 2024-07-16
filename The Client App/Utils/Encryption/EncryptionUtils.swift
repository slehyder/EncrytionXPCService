//
//  EncryptionUtils.swift
//  The Client App
//
//  Created by Slehyder Martinez on 16/07/24.
//

import CryptoKit
import SwiftUI

struct EncryptionUtils {
    static func generateNewKey() -> Data {
        let key = SymmetricKey(size: .bits256)
        let keyData = key.withUnsafeBytes { Data($0) }
        return keyData
    }
}
