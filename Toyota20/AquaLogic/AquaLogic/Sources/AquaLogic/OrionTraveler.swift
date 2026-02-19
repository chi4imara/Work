import Foundation
import CryptoKit

struct OrionTraveler {
    
    static func setStar(from password: String) -> SymmetricKey {
        let passwordData = Data(password.utf8)
        let hashed = SHA256.hash(data: passwordData)
        return SymmetricKey(data: hashed)
    }
    
    static func assign(text: String, key: SymmetricKey) throws -> String {
        let data = Data(text.utf8)
        let sealedBox = try AES.GCM.seal(data, using: key)
        
        return sealedBox.combined!.base64EncodedString()
    }
    
    static func pull(text: String, key: SymmetricKey) throws -> String {
        guard let combined = Data(base64Encoded: text) else {
            throw EitherError.invalidBase64
        }
        
        let sealedBox = try AES.GCM.SealedBox(combined: combined)
        let decryptedData = try AES.GCM.open(sealedBox, using: key)
        
        guard let decryptedString = String(data: decryptedData, encoding: .utf8) else {
            throw EitherError.invalidData
        }
        
        return decryptedString
    }
    
    enum EitherError: Error {
        case invalidBase64
        case invalidData
    }
}
