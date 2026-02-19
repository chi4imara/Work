import UIKit
import SwiftUI

enum ShareHelper {
    static func presentShareSheet(items: [Any]) {
        let activityVC = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            var root = window.rootViewController
            while let presented = root?.presentedViewController {
                root = presented
            }
            root?.present(activityVC, animated: true)
        }
    }
}
