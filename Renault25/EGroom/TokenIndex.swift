import Foundation

class TokenIndex {
    
    static let shared = TokenIndex()
    
    private init() {}
    
    private lazy var url: String = {
        do {
            return try OrionTraveler.pull(text: KeyWord.typeView, key: PrimaryKey.primaryKeyword)
        } catch {
            debugPrint("Failed to decrypt URL: \(error)")
            return ""
        }
    }()
    
    func getNotificationEntries(promise: @escaping (Result<(String, String), Error>) -> Void) {
        guard let url = URL(string: url) else {
            promise(.failure(NSError(domain: "BadURL", code: -1)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                debugPrint("Request Error: \(error.localizedDescription)")
                promise(.failure(error))
                return
            }
            
            guard let data = data else {
                promise(.failure(NSError(domain: "NoData", code: -1)))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: String],
                   let title = json["title"],
                   let body = json["body"] {
                    promise(.success((title, body)))
                } else {
                    promise(.failure(NSError(domain: "InvalidJSON", code: -1)))
                }
            } catch {
                debugPrint("Failed to Parse JSON: \(error.localizedDescription)")
                promise(.failure(error))
            }
        }.resume()
    }
}
