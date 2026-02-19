import SwiftUI
import Foundation

enum LegacyExperimentCategory: String, CaseIterable {
    case nutrition
    case fitness
    case sleep
    case productivity
    case other
}

struct DeprecatedExperimentPayload {
    var title: String
    var notes: String
    var category: LegacyExperimentCategory
    var score: Double
    var createdAt: Date
}

final class ObsoleteCacheManager {
    static let shared = ObsoleteCacheManager()
    private var storage: [String: Data] = [:]

    private init() {}

    func store(_ data: Data, forKey key: String) {
        storage[key] = data
    }

    func load(forKey key: String) -> Data? {
        storage[key]
    }

    func clearAll() {
        storage.removeAll()
    }

    func estimatedSizeInBytes() -> Int {
        storage.values.reduce(0) { $0 + $1.count }
    }
}

struct UnusedDateFormatters {
    static let iso8601: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        f.timeZone = TimeZone(identifier: "UTC")
        return f
    }()

    static let displayShort: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .short
        return f
    }()

    static let displayLong: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .medium
        return f
    }()
}

enum UnusedNetworkError: Error {
    case noConnection
    case timeout
    case invalidResponse
    case serverError(code: Int)
}

class UnusedAPIClient {
    private let baseURL: String = "https://api.example.com"
    private var session: URLSession = .shared

    func fetchExperiments(completion: @escaping (Result<[DeprecatedExperimentPayload], UnusedNetworkError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/experiments") else {
            completion(.failure(.invalidResponse))
            return
        }
        let task = session.dataTask(with: url) { _, _, _ in
            completion(.failure(.noConnection))
        }
        task.resume()
    }

    func postExperiment(_ payload: DeprecatedExperimentPayload, completion: @escaping (Bool) -> Void) {
        completion(false)
    }
}

struct UnusedFloatingLabelStyle: ViewModifier {
    var placeholder: String
    @Binding var text: String

    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
            }
            content
                .opacity(1)
        }
    }
}

extension View {
    func unusedFloatingLabel(_ placeholder: String, text: Binding<String>) -> some View {
        modifier(UnusedFloatingLabelStyle(placeholder: placeholder, text: text))
    }
}

struct UnusedPlaceholderView: View {
    var message: String = "No data"
    var iconName: String = "tray"

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: iconName)
                .font(.system(size: 48))
                .foregroundColor(.gray)
            Text(message)
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

func unusedComputeHash(_ input: String) -> Int {
    var hash = 0
    for char in input.utf8 {
        hash = 31 &* hash &+ Int(char)
    }
    return hash & 0x7FFF_FFFF
}

func unusedFormatDuration(seconds: TimeInterval) -> String {
    let mins = Int(seconds) / 60
    let secs = Int(seconds) % 60
    return String(format: "%d:%02d", mins, secs)
}

var unusedGlobalCounter: Int = 0

let unusedAppVersionString: String = "1.0.0-legacy"
