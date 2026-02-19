import SwiftUI
import StoreKit

struct SettingsView: View {
    @EnvironmentObject var workoutsVM: WorkoutsViewModel
    @EnvironmentObject var userProfileVM: UserProfileViewModel
    @EnvironmentObject var progressVM: ProgressViewModel
    @State private var showRateAlert = false
    @State private var showSampleDataLoaded = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Settings")
                            .font(.ubuntu(24, weight: .bold))
                            .foregroundColor(ColorTheme.textPrimary)
                        
                        Text("App preferences and information")
                            .font(.ubuntu(14, weight: .regular))
                            .foregroundColor(ColorTheme.textSecondary)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        SettingsSection(title: "App") {
                            VStack(spacing: 0) {
                                Divider()
                                    .overlay {
                                        Color.white
                                    }
                                    .padding(.horizontal, -20)
                                
                                SettingsRow(
                                    title: "Rate App",
                                    icon: "star.fill",
                                    iconColor: ColorTheme.primaryYellow
                                ) {
                                    requestReview()
                                }
                                
                                Divider()
                                    .overlay {
                                        Color.white
                                    }
                                    .padding(.horizontal, -20)
                                
                                SettingsRow(
                                    title: "Contact Us",
                                    icon: "envelope.fill",
                                    iconColor: ColorTheme.accentPurple
                                ) {
                                    openURL("https://forms.gle/zSgtYEgHJEjDXAcn8")
                                }
                                
                                Divider()
                                    .overlay {
                                        Color.white
                                    }
                                    .padding(.horizontal, -20)
                            }
                        }
                        
                        SettingsSection(title: "Legal") {
                            VStack(spacing: 0) {
                                Divider()
                                    .overlay {
                                        Color.white
                                    }
                                    .padding(.horizontal, -20)
                                
                                SettingsRow(
                                    title: "Privacy Policy",
                                    icon: "lock.shield.fill",
                                    iconColor: Color.red
                                ) {
                                    openURL("https://doc-hosting.flycricket.io/youmotion-habit-privacy-policy/f533f92a-8dca-477a-8645-4f06a6b59f8d/privacy")
                                }
                                
                                Divider()
                                    .overlay {
                                        Color.white
                                    }
                                    .padding(.horizontal, -20)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .alert("Rate FitApp", isPresented: $showRateAlert) {
            Button("Rate Now") {
                requestReview()
            }
            Button("Later", role: .cancel) {}
        } message: {
            Text("Enjoying FitApp? Please take a moment to rate us in the App Store!")
        }
        .alert("Sample Data Loaded", isPresented: $showSampleDataLoaded) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Sample workouts, profile, scheduled sessions, and progress have been loaded. Switch tabs to see the data.")
        }
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(ColorTheme.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.cardBorder, lineWidth: 1)
        )
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorTheme.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ColorTheme.textSecondary)
            }
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
    }
}

struct CreativeSettingsSection: View {
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 16) {
                Text("Quick Actions")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                
                HStack(spacing: 20) {
                    Spacer()
                    
                    HexagonButton(
                        title: "Rate",
                        icon: "star.fill",
                        color: ColorTheme.primaryYellow
                    ) {
                        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                            SKStoreReviewController.requestReview(in: scene)
                        }
                    }
                    
                    HexagonButton(
                        title: "Email",
                        icon: "envelope.fill",
                        color: ColorTheme.accentPurple
                    ) {
                        if let url = URL(string: "https://google.com") {
                            UIApplication.shared.open(url)
                        }
                    }
                    
                    Spacer()
                }
                
                HexagonButton(
                    title: "Privacy",
                    icon: "lock.shield.fill",
                    color: ColorTheme.accentGreen
                ) {
                    if let url = URL(string: "https://google.com") {
                        UIApplication.shared.open(url)
                    }
                }
            }
            .padding(20)
            .background(ColorTheme.cardBackground)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(ColorTheme.cardBorder, lineWidth: 1)
            )
            
            VStack(spacing: 16) {
                Text("Connect")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                
                ZStack {
                    Circle()
                        .stroke(ColorTheme.cardBorder, lineWidth: 2)
                        .frame(width: 200, height: 200)
                    
                    CircleButton(
                        icon: "heart.fill",
                        color: ColorTheme.errorRed,
                        size: 60
                    ) {
                    }
                    
                    ForEach(0..<4, id: \.self) { index in
                        let angle = Double(index) * 90 * .pi / 180
                        let radius: CGFloat = 80
                        let x = cos(angle) * radius
                        let y = sin(angle) * radius
                        
                        CircleButton(
                            icon: ["star.fill", "envelope.fill", "lock.shield.fill", "gear.badge"][index],
                            color: [ColorTheme.primaryYellow, ColorTheme.accentPurple, ColorTheme.accentGreen, ColorTheme.accentOrange][index],
                            size: 40
                        ) {
                            handleCircleAction(index)
                        }
                        .offset(x: x, y: y)
                    }
                }
                .frame(height: 220)
            }
            .padding(20)
            .background(ColorTheme.cardBackground)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(ColorTheme.cardBorder, lineWidth: 1)
            )
        }
    }
    
    private func handleCircleAction(_ index: Int) {
        switch index {
        case 0:
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        case 1:
            if let url = URL(string: "https://google.com") {
                UIApplication.shared.open(url)
            }
        case 2:
            if let url = URL(string: "https://google.com") {
                UIApplication.shared.open(url)
            }
        case 3:
            break
        default:
            break
        }
    }
}

struct HexagonButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    HexagonShape()
                        .fill(color.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    HexagonShape()
                        .stroke(color, lineWidth: 2)
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(ColorTheme.textPrimary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CircleButton: View {
    let icon: String
    let color: Color
    let size: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: size, height: size)
                
                Circle()
                    .stroke(color, lineWidth: 2)
                    .frame(width: size, height: size)
                
                Image(systemName: icon)
                    .font(.system(size: size * 0.3, weight: .bold))
                    .foregroundColor(color)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.size.width
        let height = rect.size.height
        let centerX = width / 2
        let centerY = height / 2
        let radius = min(width, height) / 2
        
        for i in 0..<6 {
            let angle = Double(i) * 60.0 * .pi / 180.0
            let x = centerX + radius * cos(angle)
            let y = centerY + radius * sin(angle)
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        path.closeSubpath()
        return path
    }
}
