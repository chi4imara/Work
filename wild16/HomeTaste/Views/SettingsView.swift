import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateApp = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        HStack {
                            Text("Settings")
                                .font(FontManager.title1)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 30)
                        
                        GeometryReader { geometry in
                            CircularSettingsLayout(
                                geometry: geometry,
                                settingsItems: settingsItems,
                                onItemTap: handleSettingsTap
                            )
                        }
                        .frame(height: 400)
                        
                        VStack(spacing: 20) {
                            VStack(spacing: 8) {
                                Text("Recipe Helper")
                                    .font(FontManager.title3)
                                    .foregroundColor(AppColors.textPrimary)
                                HStack {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(AppColors.accent)
                                    Text("Made with love for home cooking")
                                        .font(FontManager.caption1)
                                        .foregroundColor(AppColors.textSecondary)
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(AppColors.accent)
                                }
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity)
                            .background(AppColors.cardGradient)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 40)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .alert("Rate Our App", isPresented: $showingRateApp) {
            Button("Not Now", role: .cancel) { }
            Button("Rate App") {
                requestAppStoreReview()
            }
        } message: {
            Text("If you enjoy using Recipe Helper, please consider rating us on the App Store!")
        }
    }
    
    private let settingsItems: [SettingsItem] = [
        SettingsItem(
            title: "Terms of Use",
            icon: "doc.text",
            color: AppColors.primaryBlue,
            action: .openURL
        ),
        SettingsItem(
            title: "Privacy Policy",
            icon: "lock.shield",
            color: AppColors.success,
            action: .openURL
        ),
        SettingsItem(
            title: "Contact Us",
            icon: "envelope",
            color: AppColors.accent,
            action: .openURL
        ),
        SettingsItem(
            title: "Rate App",
            icon: "star.fill",
            color: AppColors.primaryYellow,
            action: .rateApp
        )
    ]
    
    private func handleSettingsTap(_ item: SettingsItem) {
        switch item.action {
        case .openURL:
            if let url = URL(string: item.title == "Terms of Use" ? "https://www.privacypolicies.com/live/f537dd03-2079-473d-9951-4bd47d7b9145" : item.title == "Privacy Policy" ? "https://www.privacypolicies.com/live/c3188f4e-904b-400b-8de7-3e957fbf3852" : "https://www.privacypolicies.com/live/c3188f4e-904b-400b-8de7-3e957fbf3852") {
                UIApplication.shared.open(url)
            }
        case .rateApp:
            showingRateApp = true
        }
    }
    
    private func requestAppStoreReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsItem {
    let title: String
    let icon: String
    let color: Color
    let action: SettingsAction
}

enum SettingsAction {
    case openURL
    case rateApp
}

struct CircularSettingsLayout: View {
    let geometry: GeometryProxy
    let settingsItems: [SettingsItem]
    let onItemTap: (SettingsItem) -> Void
    
    private var center: CGPoint {
        CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
    }
    
    private var radius: CGFloat {
        min(geometry.size.width, geometry.size.height) * 0.35
    }
    
    private func angle(for index: Int) -> Double {
        Double(index) * (2 * .pi / Double(settingsItems.count)) - .pi / 2
    }
    
    private func position(for index: Int) -> CGPoint {
        let angle = angle(for: index)
        let x = center.x + radius * cos(angle)
        let y = center.y + radius * sin(angle)
        return CGPoint(x: x, y: y)
    }
    
    var body: some View {
        ZStack {
            CentralGearIcon(center: center)
            
            ForEach(Array(settingsItems.enumerated()), id: \.offset) { index, item in
                let position = position(for: index)
                
                SettingsButton(
                    item: item,
                    onTap: {
                        onItemTap(item)
                    }
                )
                .position(x: position.x, y: position.y)
            }
            
            ConnectingLinesView(
                center: center,
                radius: radius,
                itemCount: settingsItems.count
            )
        }
    }
}

struct CentralGearIcon: View {
    let center: CGPoint
    
    var body: some View {
        Circle()
            .fill(AppColors.cardGradient)
            .frame(width: 80, height: 80)
            .position(center)
            .overlay(
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 30))
                    .foregroundColor(AppColors.primaryBlue)
                    .position(center)
            )
    }
}

struct ConnectingLinesView: View {
    let center: CGPoint
    let radius: CGFloat
    let itemCount: Int
    
    private func angle(for index: Int) -> Double {
        Double(index) * (2 * .pi / Double(itemCount)) - .pi / 2
    }
    
    private func linePath(for index: Int) -> Path {
        let angle = angle(for: index)
        let cosAngle = cos(angle)
        let sinAngle = sin(angle)
        
        let startX = center.x + 40 * cosAngle
        let startY = center.y + 40 * sinAngle
        let endX = center.x + (radius - 40) * cosAngle
        let endY = center.y + (radius - 40) * sinAngle
        
        var path = Path()
        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: CGPoint(x: endX, y: endY))
        return path
    }
    
    var body: some View {
        ForEach(0..<itemCount, id: \.self) { index in
            linePath(for: index)
                .stroke(AppColors.primaryBlue.opacity(0.2), lineWidth: 1)
        }
    }
}

struct SettingsButton: View {
    let item: SettingsItem
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
                onTap()
            }
        }) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(item.color.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .fill(item.color)
                        .frame(width: 50, height: 50)
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                    
                    Image(systemName: item.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                }
                
                Text(item.title)
                    .font(FontManager.caption1)
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(width: 80)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
}
