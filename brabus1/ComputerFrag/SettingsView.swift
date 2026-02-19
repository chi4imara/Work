import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var viewModel: DeviceViewModel
    @State private var showingRateApp = false
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 24) {
                        profileSection
                        
                        settingsGrid
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(.ubuntu(32, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var profileSection: some View {
        VStack(spacing: 16) {
            Circle()
                .fill(ColorTheme.accentYellow.opacity(0.3))
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 40, weight: .medium))
                        .foregroundColor(ColorTheme.accentYellow)
                )
            
            VStack(spacing: 4) {
                Text("Tech Enthusiast")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("\(viewModel.devices.count) device\(viewModel.devices.count == 1 ? "" : "s") • \(viewModel.allImprovements.count) improvement\(viewModel.allImprovements.count == 1 ? "" : "s")")
                    .font(.ubuntu(14))
                    .foregroundColor(ColorTheme.secondaryText)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .cardStyle()
    }
    
    private var settingsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ], spacing: 16) {
            SettingsCard(
                icon: "shield.checkered",
                title: "Privacy Policy",
                subtitle: "Data protection",
                color: ColorTheme.info
            ) {
                openURL("https://www.privacypolicies.com/live/dc45fff7-2f6c-4389-8fd7-79c545067f13")
            }
            
            SettingsCard(
                icon: "envelope.fill",
                title: "Contact Us",
                subtitle: "Get in touch",
                color: ColorTheme.success
            ) {
                openURL("https://www.privacypolicies.com/live/dc45fff7-2f6c-4389-8fd7-79c545067f13")
            }
            
            SettingsCard(
                icon: "star.fill",
                title: "Rate App",
                subtitle: "Show support",
                color: ColorTheme.warning
            ) {
                requestReview()
            }
            
            SettingsCard(
                icon: "arrow.clockwise",
                title: "Reset Data",
                subtitle: "Sample data",
                color: ColorTheme.error
            ) {
                viewModel.resetToSampleData()
            }
        }
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 12) {
            Text("ComputerFrag")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Text("Plan every tech upgrade with clarity")
                .font(.ubuntu(12))
                .foregroundColor(ColorTheme.secondaryText.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .cardStyle()
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(color)
                    )
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.ubuntu(14, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                        .multilineTextAlignment(.center)
                    
                    Text(subtitle)
                        .font(.ubuntu(11))
                        .foregroundColor(ColorTheme.secondaryText)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .cardStyle()
        }
    }
}

struct HexagonalSettingsView: View {
    @ObservedObject var viewModel: DeviceViewModel
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                Text("Settings")
                    .font(.ubuntu(32, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                    .padding(.top, 50)
                
                Spacer()
                
                ZStack {
                    HexagonButton(
                        icon: "person.fill",
                        title: "Profile",
                        size: 80,
                        color: ColorTheme.accentYellow
                    ) {
                    }
                    
                    ForEach(0..<6) { index in
                        let angle = Double(index) * 60.0 * .pi / 180.0
                        let radius: CGFloat = 120
                        let x = cos(angle) * radius
                        let y = sin(angle) * radius
                        
                        HexagonButton(
                            icon: hexagonIcons[index],
                            title: hexagonTitles[index],
                            size: 60,
                            color: hexagonColors[index]
                        ) {
                            hexagonActions[index]()
                        }
                        .offset(x: x, y: y)
                    }
                }
                
                Spacer()
                Spacer()
            }
        }
    }
    
    private let hexagonIcons = ["shield.checkered", "envelope.fill", "star.fill", "arrow.clockwise", "info.circle", "gear"]
    private let hexagonTitles = ["Privacy", "Contact", "Rate", "Reset", "Info", "More"]
    private let hexagonColors = [ColorTheme.info, ColorTheme.success, ColorTheme.warning, ColorTheme.error, ColorTheme.accentYellow, ColorTheme.primaryPink]
    
    private var hexagonActions: [() -> Void] {
        [
            { openURL("https://google.com") },
            { openURL("https://google.com") },
            { requestReview() },
            { viewModel.resetToSampleData() },
            { openURL("https://google.com") },
            { openURL("https://google.com") }
        ]
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct HexagonButton: View {
    let icon: String
    let title: String
    let size: CGFloat
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    Hexagon()
                        .fill(color.opacity(0.2))
                        .frame(width: size, height: size)
                        .overlay(
                            Hexagon()
                                .stroke(color, lineWidth: 2)
                        )
                    
                    Image(systemName: icon)
                        .font(.system(size: size * 0.3, weight: .medium))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.ubuntu(10, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct Hexagon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        for i in 0..<6 {
            let angle = Double(i) * 60.0 * .pi / 180.0
            let x = center.x + cos(angle) * radius
            let y = center.y + sin(angle) * radius
            
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

#Preview {
    SettingsView(viewModel: DeviceViewModel())
}
