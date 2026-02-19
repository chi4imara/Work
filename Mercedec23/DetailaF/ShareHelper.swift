import SwiftUI
import UIKit

enum ShareHelper {
    
    private static func topViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController ?? windowScene.windows.first?.rootViewController else {
            return nil
        }
        var topVC = rootVC
        while let presented = topVC.presentedViewController {
            topVC = presented
        }
        return topVC
    }
    
    static func share(items: [Any]) {
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        if let topVC = topViewController() {
            if UIDevice.current.userInterfaceIdiom == .pad, let popover = activityVC.popoverPresentationController, let view = topVC.view {
                popover.sourceView = view
                popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
                popover.permittedArrowDirections = []
            }
            topVC.present(activityVC, animated: true)
        }
    }
    
    static func shareCollection(_ collection: Collection) {
        let header = "\(collection.name)\nCreated: \(collection.createdDate.formatted(date: .abbreviated, time: .omitted))\n"
        let list = collection.accessories.enumerated().map { index, a in
            "\(index + 1). \(a.name) – \(a.brand), \(a.category.rawValue), $\(Int(a.price))"
        }.joined(separator: "\n")
        let text = list.isEmpty ? header + "No items yet." : header + "\n" + list
        share(items: [text])
    }
    
    static func shareApp() {
        let url = URL(string: "https://google.com")!
        let text = "Check out AccessorizeHer – discover the perfect accessories for any outfit."
        share(items: [text, url])
    }
}
