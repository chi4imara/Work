import SwiftUI
import UIKit

extension View {
    func setupNavigationBarAppearance() -> some View {
        self.onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = UIColor(AppColors.secondaryBackground)
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor(AppColors.primaryText),
                .font: UIFont(name: "Ubuntu-Bold", size: 18) ?? UIFont.boldSystemFont(ofSize: 18)
            ]
            appearance.largeTitleTextAttributes = [
                .foregroundColor: UIColor(AppColors.primaryText),
                .font: UIFont(name: "Ubuntu-Bold", size: 34) ?? UIFont.boldSystemFont(ofSize: 34)
            ]
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
        }
    }
}

extension String {
    var isValidTime: Bool {
        let timeRegex = "^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$"
        return NSPredicate(format: "SELF MATCHES %@", timeRegex).evaluate(with: self)
    }
}

extension Date {
    func timeString() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: self)
    }
}
