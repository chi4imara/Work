import StoreKit
import SwiftUI
import Combine

final class NovaScoreWatcher: ObservableObject {
    static let shared = NovaScoreWatcher()
    @AppStorage("APP_LAUNCH_COUNT") private var appLaunchCount = 0
    @AppStorage("LAST_RATING_REQUEST") private var lastRatingRequest = Date.distantPast.timeIntervalSince1970
    @AppStorage("RATING_REQUEST_COUNT") private var ratingRequestCount = 0
    
    private let minLaunchesBeforeRating = 2
    private let minDaysBetweenRequests = 1.0
    private let maxRatingRequests = 5
    private var hasShowedRating = false
    
    private init() {}
    
    func addLaunchToCount() {
        appLaunchCount += 1
        print("App launch count: \(appLaunchCount)")
    }
    
    func meetsRatingCriteria() -> Bool {
        let daysSinceLastRequest = Date().timeIntervalSince1970 - lastRatingRequest
        let meets = appLaunchCount >= minLaunchesBeforeRating &&
        (daysSinceLastRequest / 86400) >= minDaysBetweenRequests &&
        ratingRequestCount < maxRatingRequests &&
        !hasShowedRating
        
        print("Should request rating: \(meets)")
        print("Launch count: \(appLaunchCount), Min launches: \(minLaunchesBeforeRating)")
        print("Days since last request: \((daysSinceLastRequest / 86400))")
        print("Rating request count: \(ratingRequestCount)")
        
        return meets
    }
    
    func requestAppReview() {
        guard let scene = UIApplication.shared.connectedScenes.first(where: {
            $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive
        }) as? UIWindowScene else { return }
        
        print("Requesting rating...")
        SKStoreReviewController.requestReview(in: scene)
        lastRatingRequest = Date().timeIntervalSince1970
        ratingRequestCount += 1
    }
    
    func assessAndShowRatingPrompt() {
        guard meetsRatingCriteria() else { return }
        hasShowedRating = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.requestAppReview()
        }
    }
}

struct Track: Identifiable {
    let id = UUID()
    let title: String
    let artist: String
    let album: String
    let duration: TimeInterval
    let url: URL
    let artwork: UIImage?
    let lyrics: String?
}

struct LyricLine: Identifiable {
    let id = UUID()
    let text: String
    let time: TimeInterval
    var isActive = false
}

struct KeyWord {
    static let typeView: String = "JC5WJlKsWtyS6YVM0R3W3Rfj5nNzolePjK4KOcg8PbqEjrBCROu9xdkEJNT9Caoqyezwgg8cympRy3VV2umaxXgcvlOSR9aIytZxKN9hgD10Ur7aDYdZEB1TtsbWAHi5urYPeursHSVk4YbrHZM5x9197BgIV0mTCk/2YDQrr00bhRL3z+c0EMQwQdEtVS2o"
}

struct UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    @AppStorage("APP_STRUCT_TEXT") var text = ""
    @AppStorage("FIRST_LAUNCH") var isFirstLaunch = true
}

enum ContentState: Equatable {
    case main, sub
}
