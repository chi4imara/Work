import Foundation

class AppSettings: ObservableObject {
    @Published var useExtendedMoods: Bool {
        didSet {
            UserDefaults.standard.set(useExtendedMoods, forKey: "useExtendedMoods")
        }
    }
    
    @Published var commentLimit: CommentLimit {
        didSet {
            UserDefaults.standard.set(commentLimit.rawValue, forKey: "commentLimit")
        }
    }
    
    @Published var hasCompletedOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
        }
    }
    
    init() {
        self.useExtendedMoods = UserDefaults.standard.bool(forKey: "useExtendedMoods")
        self.commentLimit = CommentLimit(rawValue: UserDefaults.standard.integer(forKey: "commentLimit")) ?? .medium
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }
}

enum CommentLimit: Int, CaseIterable {
    case short = 50
    case medium = 150
    case long = 300
    
    var description: String {
        switch self {
        case .short: return "Short (up to 50 characters)"
        case .medium: return "Medium (up to 150 characters)"
        case .long: return "Long (up to 300 characters)"
        }
    }
}
