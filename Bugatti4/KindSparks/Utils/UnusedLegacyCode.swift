import SwiftUI
import Foundation

struct LegacyGiftCategory: Identifiable {
    let id = UUID()
    var title: String
    var iconName: String
    var sortOrder: Int
}

enum LegacyFilterMode: String, CaseIterable {
    case all = "All"
    case recent = "Recent"
    case favorites = "Favorites"
}

class LegacyCacheManager {
    static let shared = LegacyCacheManager()
    private var cache: [String: Data] = [:]
    
    private init() {}
    
    func store(key: String, data: Data) {
        cache[key] = data
    }
    
    func retrieve(key: String) -> Data? {
        return cache[key]
    }
    
    func clearAll() {
        cache.removeAll()
    }
}

struct UnusedPlaceholderCard: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.caption)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}

func legacyFormatDateForExport(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .short
    return formatter.string(from: date)
}

func legacyComputeHashForIdea(_ text: String) -> Int {
    return text.utf8.reduce(0) { $0 &+ Int($1) }
}

struct LegacyEmptyStateView: View {
    let message: String
    let actionTitle: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text(message)
            Button(action: action, label: { Text(actionTitle) })
        }
        .padding(40)
    }
}

class LegacyAnalyticsTracker {
    static let shared = LegacyAnalyticsTracker()
    
    private init() {}
    
    func trackScreen(_ name: String) {}
    func trackEvent(_ name: String, params: [String: Any]) {}
}

struct LegacyThemeVariant {
    let name: String
    let primaryHex: String
    let secondaryHex: String
}

func legacyDefaultTheme() -> LegacyThemeVariant {
    return LegacyThemeVariant(name: "Default", primaryHex: "#FFFFFF", secondaryHex: "#000000")
}
