import UIKit
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(ColorTheme.primaryBackground.opacity(0.95))
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(ColorTheme.primaryText),
            .font: UIFont(name: "PlayfairDisplay-SemiBold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]
        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(ColorTheme.primaryText),
            .font: UIFont(name: "PlayfairDisplay-Bold", size: 32) ?? UIFont.systemFont(ofSize: 32, weight: .bold)
        ]
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        return true
    }
}
