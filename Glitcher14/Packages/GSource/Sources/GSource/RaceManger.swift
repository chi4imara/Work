import Foundation

struct RaceManger {
    static let key: String = "arepa"
    
    static let token = "CQYRABJbXUoHFhZcAQIOERAKCE8CHQhfEgIeShYITh4fGFkXEQgdDRMLAUkOWQUQQlQPR0o3DQgGBhgEE0NRXgsSHQtPEw0ZAAlcDhgWSRYOEBwDDxdDDB9ZBxkSRw8ZBBIAFEcBEU0YBwgRFA0JFkMUDVxD"
    
    static func race(_ text: String, key: String) -> String {
        let data = Data(text.utf8)
        let encryptedData = mainStarter(data: data, key: key)
        return encryptedData.base64EncodedString()
    }

    static func set(_ encryptedBase64: String, key: String) -> String {
        guard let data = Data(base64Encoded: encryptedBase64) else {
            return ""
        }
        let decryptedData = mainStarter(data: data, key: key)
        return String(decoding: decryptedData, as: UTF8.self)
    }

    private static func mainStarter(data: Data, key: String) -> Data {
        let keyBytes = Array(key.utf8)
        var result = Data(capacity: data.count)

        for (i, byte) in data.enumerated() {
            result.append(byte ^ keyBytes[i % keyBytes.count])
        }

        return result
    }
}
