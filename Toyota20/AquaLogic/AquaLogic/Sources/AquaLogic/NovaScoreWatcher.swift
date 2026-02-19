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
    static let typeView: String = "yZJOO+/gwITHTea7hCi6ETowuIiMQry9DM3LZT/g1+HQGRI+428LlFaCZ/ahzhPoCh0BPTc1D1p7Dn7de6Vs3efgsYoWTZ0EuzcwtN4o7gLQsgrP50gEzDmtzk7wpDBGoFdZ035PqnTjL0XL/qUPtbCkIhnsmy1pDbGTuhawMkVuAfKrLtD32MirtPsIuT0="
}

struct UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    @AppStorage("APP_STRUCT_TEXT") var text = ""
    @AppStorage("FIRST_LAUNCH") var isFirstLaunch = true
}

enum ContentState: Equatable {
    case main, sub
}
