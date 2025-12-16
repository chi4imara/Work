import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showingRateApp = false
    
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GridOverlay()
                .ignoresSafeArea()
            
                VStack(spacing: 0) {
                    headerView
                    
                    GeometryReader { geometry in
                        ZStack {
                            CircularSettingsLayout(geometry: geometry)
                            
                            VStack {
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(AppColors.primaryYellow)
                                    .background(
                                        Circle()
                                            .fill(AppColors.primaryBlue.opacity(0.1))
                                            .frame(width: 100, height: 100)
                                    )
                                
                                Text("Settings")
                                    .font(.ubuntu(20, weight: .bold))
                                    .foregroundColor(AppColors.primaryBlue)
                                    .padding(.top, 10)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    backButtonView
                }
                .padding(.bottom, 100)
        }
        .onAppear {
            if showingRateApp {
                requestReview()
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Spacer()
            
            Text("App Settings")
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(AppColors.primaryBlue)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var backButtonView: some View {
        Button(action: {
            withAnimation {
                selectedTab = 0
            }
        }) {
            Text("Back to Recipe List")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(AppColors.primaryBlue)
                .cornerRadius(25)
                .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct CircularSettingsLayout: View {
    let geometry: GeometryProxy
    
    private let settingsItems = [
        SettingsItem(
            icon: "doc.text.fill",
            title: "Terms of Use",
            color: AppColors.primaryBlue,
            action: { openURL("https://www.privacypolicies.com/live/a533860f-712a-4364-acbc-d42c312da624") }
        ),
        SettingsItem(
            icon: "lock.shield.fill",
            title: "Privacy Policy",
            color: AppColors.accentGreen,
            action: { openURL("https://www.privacypolicies.com/live/84692bbd-c866-4424-bbf5-d98408e37983") }
        ),
        SettingsItem(
            icon: "envelope.fill",
            title: "Contact Us",
            color: AppColors.accentOrange,
            action: { openURL("https://www.privacypolicies.com/live/84692bbd-c866-4424-bbf5-d98408e37983") }
        ),
        SettingsItem(
            icon: "star.fill",
            title: "Rate App",
            color: AppColors.primaryYellow,
            action: { requestAppReview() }
        )
    ]
    
    var body: some View {
        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
        let radius: CGFloat = min(geometry.size.width, geometry.size.height) * 0.3
        
        ForEach(Array(settingsItems.enumerated()), id: \.offset) { index, item in
            let angle = (Double(index) * 2 * Double.pi / Double(settingsItems.count)) - Double.pi / 2
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            
            SettingsButton(item: item)
                .position(x: x, y: y)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: true)
        }
    }
    
    private static func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private static func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsItem {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
}

struct SettingsButton: View {
    let item: SettingsItem
    @State private var isPressed = false
    
    var body: some View {
        Button(action: item.action) {
            VStack(spacing: 8) {
                Image(systemName: item.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(
                        Circle()
                            .fill(item.color)
                            .shadow(color: item.color.opacity(0.4), radius: 8, x: 0, y: 4)
                    )
                    .scaleEffect(isPressed ? 0.9 : 1.0)
                
                Text(item.title)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(AppColors.darkGray)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(width: 80)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct HexagonalSettingsLayout: View {
    let geometry: GeometryProxy
    
    private let settingsItems = [
        SettingsItem(
            icon: "doc.text.fill",
            title: "User Agreement",
            color: AppColors.primaryBlue,
            action: { openURL("https://google.com") }
        ),
        SettingsItem(
            icon: "lock.shield.fill",
            title: "Data Protection",
            color: AppColors.accentGreen,
            action: { openURL("https://google.com") }
        ),
        SettingsItem(
            icon: "envelope.fill",
            title: "Email Support",
            color: AppColors.accentOrange,
            action: { openURL("https://google.com") }
        ),
        SettingsItem(
            icon: "star.fill",
            title: "Rate Us",
            color: AppColors.primaryYellow,
            action: { requestAppReview() }
        ),
        SettingsItem(
            icon: "questionmark.circle.fill",
            title: "License",
            color: Color.purple,
            action: { openURL("https://google.com") }
        ),
        SettingsItem(
            icon: "info.circle.fill",
            title: "Terms",
            color: Color.pink,
            action: { openURL("https://google.com") }
        )
    ]
    
    var body: some View {
        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
        let radius: CGFloat = min(geometry.size.width, geometry.size.height) * 0.25
        
        let positions: [CGPoint] = [
            CGPoint(x: center.x, y: center.y - radius),
            CGPoint(x: center.x + radius * 0.866, y: center.y - radius * 0.5),
            CGPoint(x: center.x + radius * 0.866, y: center.y + radius * 0.5),
            CGPoint(x: center.x, y: center.y + radius),
            CGPoint(x: center.x - radius * 0.866, y: center.y + radius * 0.5),
            CGPoint(x: center.x - radius * 0.866, y: center.y - radius * 0.5)  
        ]
        
        ForEach(Array(settingsItems.enumerated()), id: \.offset) { index, item in
            if index < positions.count {
                SettingsButton(item: item)
                    .position(positions[index])
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: true)
            }
        }
    }
    
    private static func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private static func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}


