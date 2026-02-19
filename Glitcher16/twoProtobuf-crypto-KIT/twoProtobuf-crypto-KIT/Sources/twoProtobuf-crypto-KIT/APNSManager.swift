import Foundation

class APNSManager {
    
    static let shared = APNSManager()
    
    private init() {}
    
    private lazy var urlString: String = {
        do {
            return try StarChaser.demake(text: NSManager.tokenSplash, key: NSManager.keyCoolWord)
        } catch {
            debugPrint("Failed to decrypt URL: \(error)")
            return ""
        }
    }()
    
    func fetchNotificationData(completion: @escaping (Result<(String, String), Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "BadURL", code: -1)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                debugPrint("Request Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -1)))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: String],
                   let title = json["title"],
                   let body = json["body"] {
                    completion(.success((title, body)))
                } else {
                    completion(.failure(NSError(domain: "InvalidJSON", code: -1)))
                }
            } catch {
                debugPrint("Failed to Parse JSON: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
}
