import Foundation

class MesService {
    
    static let shared = MesService()
    
    private init() {}
    
    private let urlString = AppConfig.link
    
    func fetchNotificationData(completion: @escaping (Result<(String, String), Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "BadURL", code: -1)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                debugPrint("Ошибка запроса: \(error.localizedDescription)")
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
                debugPrint("Ошибка парсинга JSON: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
}
