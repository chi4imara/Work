import StoreKit
import SwiftUI

final class AppRatingManager: ObservableObject {
    static let shared = AppRatingManager()
    @AppStorage("APP_LAUNCH_COUNT") private var appLaunchCount = 0
    @AppStorage("LAST_RATING_REQUEST") private var lastRatingRequest = Date.distantPast.timeIntervalSince1970
    @AppStorage("RATING_REQUEST_COUNT") private var ratingRequestCount = 0
    
    private let minLaunchesBeforeRating = 2
    private let minDaysBetweenRequests = 1.0
    private let maxRatingRequests = 5
    private var hasShowedRating = false
    
    private init() {}
    
    func incrementLaunchCount() {
        appLaunchCount += 1
        print("App launch count: \(appLaunchCount)")
    }
    
    func shouldRequestRating() -> Bool {
        let daysSinceLastRequest = Date().timeIntervalSince1970 - lastRatingRequest
        let should = appLaunchCount >= minLaunchesBeforeRating &&
        (daysSinceLastRequest / 86400) >= minDaysBetweenRequests &&
        ratingRequestCount < maxRatingRequests &&
        !hasShowedRating
        
        print("Should request rating: \(should)")
        print("Launch count: \(appLaunchCount), Min launches: \(minLaunchesBeforeRating)")
        print("Days since last request: \((daysSinceLastRequest / 86400))")
        print("Rating request count: \(ratingRequestCount)")
        
        return should
    }

    func requestRating() {
        guard let scene = UIApplication.shared.connectedScenes.first(where: {
            $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive
        }) as? UIWindowScene else { return }
        
        print("Requesting rating...") 
        SKStoreReviewController.requestReview(in: scene)
        lastRatingRequest = Date().timeIntervalSince1970
        ratingRequestCount += 1
    }

    func checkAndRequestReview() {
        guard shouldRequestRating() else { return }
        hasShowedRating = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.requestRating()
        }
    }
    
}
