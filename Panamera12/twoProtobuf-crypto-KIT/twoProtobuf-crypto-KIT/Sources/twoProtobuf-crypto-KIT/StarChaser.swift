import Foundation
import CryptoKit

struct StarChaser {
    
    static func createStar(from password: String) -> SymmetricKey {
        let passwordData = Data(password.utf8)
        let hashed = SHA256.hash(data: passwordData)
        return SymmetricKey(data: hashed)
    }
    
    static func make(text: String, key: SymmetricKey) throws -> String {
        let data = Data(text.utf8)
        let sealedBox = try AES.GCM.seal(data, using: key)
        
        return sealedBox.combined!.base64EncodedString()
    }
    
    static func demake(text: String, key: SymmetricKey) throws -> String {
        guard let combined = Data(base64Encoded: text) else {
            throw CryptoError.invalidBase64
        }
        
        let sealedBox = try AES.GCM.SealedBox(combined: combined)
        let decryptedData = try AES.GCM.open(sealedBox, using: key)
        
        guard let decryptedString = String(data: decryptedData, encoding: .utf8) else {
            throw CryptoError.invalidData
        }
        
        return decryptedString
    }
    
    enum CryptoError: Error {
        case invalidBase64
        case invalidData
    }
}
