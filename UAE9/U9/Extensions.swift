import SwiftUI
import Foundation

struct ProductID: Identifiable {
    let id: UUID
}

extension Date {
    var daysSinceNow: Int {
        Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    var isYesterday: Bool {
        Calendar.current.isDateInYesterday(self)
    }
    
    func formatted(style: DateFormatter.Style = .medium) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        return formatter.string(from: self)
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension String {
    var trimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isNotEmpty: Bool {
        !self.trimmed.isEmpty
    }
}

extension Array where Element == Product {
    var sortedByUpdatedDate: [Product] {
        self.sorted { $0.updatedAt > $1.updatedAt }
    }
    
    var sortedByName: [Product] {
        self.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
    
    var sortedByLastUsed: [Product] {
        self.sorted { $0.lastUsed > $1.lastUsed }
    }
    
    func filtered(by category: ProductCategory) -> [Product] {
        self.filter { $0.category == category }
    }
    
    func filtered(by status: ProductStatus) -> [Product] {
        self.filter { $0.status == status }
    }
    
    func filtered(by stockLevel: StockLevel) -> [Product] {
        self.filter { $0.stockLevel == stockLevel }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension UserDefaults {
    private enum Keys {
        static let hasSeenOnboarding = "HasSeenOnboarding"
        static let savedProducts = "SavedProducts"
        static let appLaunchCount = "AppLaunchCount"
        static let lastAppVersion = "LastAppVersion"
    }
    
    var hasSeenOnboarding: Bool {
        get { bool(forKey: Keys.hasSeenOnboarding) }
        set { set(newValue, forKey: Keys.hasSeenOnboarding) }
    }
    
    var appLaunchCount: Int {
        get { integer(forKey: Keys.appLaunchCount) }
        set { set(newValue, forKey: Keys.appLaunchCount) }
    }
    
    var lastAppVersion: String? {
        get { string(forKey: Keys.lastAppVersion) }
        set { set(newValue, forKey: Keys.lastAppVersion) }
    }
    
    func incrementLaunchCount() {
        appLaunchCount += 1
    }
}

extension Bundle {
    var appVersion: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    var buildNumber: String {
        infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    var appName: String {
        infoDictionary?["CFBundleDisplayName"] as? String ?? 
        infoDictionary?["CFBundleName"] as? String ?? "U9"
    }
}

enum HapticFeedback {
    case light
    case medium
    case heavy
    case success
    case warning
    case error
    
    func trigger() {
        switch self {
        case .light:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .medium:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .heavy:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .warning:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }
}

extension Animation {
    static let smoothSpring = Animation.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0)
    static let quickSpring = Animation.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0)
    static let gentleSpring = Animation.spring(response: 0.8, dampingFraction: 0.9, blendDuration: 0)
}
