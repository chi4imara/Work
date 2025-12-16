import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateApp = false
    @State private var appearAnimation = false
    
    private let settingsItems: [SettingsItem] = [
        SettingsItem(title: "Terms of Use", icon: "doc.text", color: Color.theme.accentOrange, url: "https://www.privacypolicies.com/live/82b31f4f-a3b1-47b6-85f5-4c292ec88db9"),
        SettingsItem(title: "Privacy Policy", icon: "lock.shield.fill", color: Color.theme.accentGreen, url: "https://www.privacypolicies.com/live/d1009a43-e1cf-4216-b439-da233cb51727"),
        SettingsItem(title: "Contact Us", icon: "envelope.fill", color: Color.theme.accentYellow, url: "https://www.privacypolicies.com/live/d1009a43-e1cf-4216-b439-da233cb51727", isRateApp: false),
        SettingsItem(title: "Rate App", icon: "star.fill", color: Color.theme.accentRed, url: nil, isRateApp: true),
        SettingsItem(title: "User Agreement", icon: "person.badge.shield.checkmark.fill", color: Color.theme.primaryPurple, url: "https://google.com"),
        SettingsItem(title: "Data Protection", icon: "shield.lefthalf.filled", color: Color.theme.secondaryPurple, url: "https://google.com")
    ]
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                ForEach(0..<5, id: \.self) { i in
                    let positions: [(CGFloat, CGFloat)] = [
                        (geometry.size.width * 0.2, geometry.size.height * 0.3),
                        (geometry.size.width * 0.8, geometry.size.height * 0.2),
                        (geometry.size.width * 0.3, geometry.size.height * 0.7),
                        (geometry.size.width * 0.7, geometry.size.height * 0.8),
                        (geometry.size.width * 0.5, geometry.size.height * 0.5)
                    ]
                    
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.theme.primaryPurple.opacity(0.1),
                                    Color.theme.secondaryPurple.opacity(0.05)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: CGFloat(100 + i * 60), height: CGFloat(100 + i * 60))
                        .position(
                            x: positions[i].0,
                            y: positions[i].1
                        )
                        .blur(radius: 20)
                        .opacity(appearAnimation ? 0.3 : 0.1)
                        .animation(
                            Animation.easeInOut(duration: 3.0 + Double(i) * 0.5)
                                .repeatForever(autoreverses: true)
                                .delay(Double(i) * 0.3),
                            value: appearAnimation
                        )
                }
            }
            
            VStack {
                HStack {
                    Text("Settings")
                        .font(.ubuntu(30, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 30) {
                        headerSection
                            .opacity(appearAnimation ? 1 : 0)
                            .offset(y: appearAnimation ? 0 : -20)
                        
                        modernSettingsGrid
                            .opacity(appearAnimation ? 1 : 0)
                            .offset(y: appearAnimation ? 0 : 20)
                        
                        appInfoSection
                            .opacity(appearAnimation ? 1 : 0)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                appearAnimation = true
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.theme.primaryPurple.opacity(0.3),
                                Color.theme.secondaryPurple.opacity(0.1),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 30,
                            endRadius: 60
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.theme.primaryPurple,
                                Color.theme.secondaryPurple,
                                Color.theme.primaryPurple
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 90, height: 90)
                    .shadow(color: Color.theme.primaryPurple.opacity(0.5), radius: 15, x: 0, y: 5)
                
                Image(systemName: "pawprint.fill")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
            }
            
            VStack(spacing: 8) {
                Text("Tailmate")
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 1)
                
                Text("Pet Care Companion")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding(.vertical, 30)
    }
    
    private var modernSettingsGrid: some View {
        VStack(spacing: 20) {
            HStack(spacing: 15) {
                ModernSettingsCard(item: settingsItems[0], delay: 0.1)
                ModernSettingsCard(item: settingsItems[1], delay: 0.2)
            }
            
            HStack(spacing: 15) {
                ModernSettingsCard(item: settingsItems[2], delay: 0.3, size: .large)
                
                ModernSettingsCard(item: settingsItems[3], delay: 0.4, size: .large)
            }
        }
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 12) {
            Divider()
                .background(Color.white.opacity(0.2))
                .padding(.horizontal, 40)
            
            Text("Made with ❤️ for pet lovers")
                .font(.ubuntu(12, weight: .regular))
                .foregroundColor(.white.opacity(0.5))
        }
        .padding(.top, 20)
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsItem {
    let title: String
    let icon: String
    let color: Color
    let url: String?
    let isRateApp: Bool
    
    init(title: String, icon: String, color: Color, url: String?, isRateApp: Bool = false) {
        self.title = title
        self.icon = icon
        self.color = color
        self.url = url
        self.isRateApp = isRateApp
    }
}

enum CardSize {
    case small
    case regular
    case large
    case wide
    
    var widthMultiplier: CGFloat {
        switch self {
        case .small: return 0.3
        case .regular: return 0.48
        case .large: return 0.48
        case .wide: return 1.0
        }
    }
    
    var height: CGFloat {
        switch self {
        case .small: return 130
        case .regular: return 150
        case .large: return 150
        case .wide: return 140
        }
    }
}

struct ModernSettingsCard: View {
    let item: SettingsItem
    let delay: Double
    var size: CardSize = .regular
    
    @State private var isPressed = false
    @State private var isVisible = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
                
                if item.isRateApp {
                    requestAppReview()
                } else if let url = item.url {
                    openURL(url)
                }
            }
        }) {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    item.color.opacity(0.3),
                                    item.color.opacity(0.1),
                                    Color.clear
                                ]),
                                center: .center,
                                startRadius: 10,
                                endRadius: 30
                            )
                        )
                        .frame(width: 60, height: 60)
                        .opacity(isPressed ? 0.5 : 1.0)
                    
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    item.color.opacity(0.25),
                                    item.color.opacity(0.15)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 55, height: 55)
                    
                    Image(systemName: item.icon)
                        .font(.system(size: size == .large ? 26 : 22, weight: .semibold))
                        .foregroundColor(item.color)
                }
                
                Text(item.title)
                    .font(.ubuntu(size == .large ? 16 : 14, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .frame(height: size.height)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.18),
                                    Color.white.opacity(0.08)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    item.color.opacity(0.4),
                                    item.color.opacity(0.2),
                                    Color.white.opacity(0.1)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                }
            )
            .shadow(
                color: item.color.opacity(isPressed ? 0.2 : 0.3),
                radius: isPressed ? 5 : 12,
                x: 0,
                y: isPressed ? 2 : 6
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .opacity(isVisible ? 1.0 : 0.0)
            .offset(y: isVisible ? 0 : 20)
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(delay)) {
                isVisible = true
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}


#Preview {
    SettingsView()
}
