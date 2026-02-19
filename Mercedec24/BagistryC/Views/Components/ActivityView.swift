import SwiftUI
import UIKit

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    var excludedTypes: [UIActivity.ActivityType] = []
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let vc = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        vc.excludedActivityTypes = excludedTypes.isEmpty ? nil : excludedTypes
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
