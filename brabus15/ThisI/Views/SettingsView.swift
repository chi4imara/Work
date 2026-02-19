import SwiftUI
import StoreKit

struct SettingsView: View {
    @EnvironmentObject var viewModel: DecisionViewModel
    @State private var showingRateAlert = false
    @State private var rotationAngle: Double = 0
    @State private var selectedButton: Int? = nil
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Settings")
                        .font(DesignSystem.Typography.largeTitle)
                        .foregroundColor(DesignSystem.Colors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: DesignSystem.Spacing.xxl) {
                        RadialSettingsLayout(
                            rotationAngle: $rotationAngle,
                            selectedButton: $selectedButton,
                            showingRateAlert: $showingRateAlert
                        )
                        
                        VStack(spacing: DesignSystem.Spacing.lg) {
                            Text("Statistics")
                                .font(DesignSystem.Typography.headline)
                                .foregroundColor(DesignSystem.Colors.primaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(spacing: DesignSystem.Spacing.md) {
                                StatisticRow(
                                    icon: "list.bullet.clipboard",
                                    title: "Total Decisions",
                                    value: "\(viewModel.decisions.count)",
                                    color: DesignSystem.Colors.yellow
                                )
                                
                                StatisticRow(
                                    icon: "calendar",
                                    title: "This Month",
                                    value: "\(decisionsThisMonth)",
                                    color: DesignSystem.Colors.success
                                )
                                
                                StatisticRow(
                                    icon: "clock.arrow.circlepath",
                                    title: "Average per Month",
                                    value: String(format: "%.1f", averagePerMonth),
                                    color: DesignSystem.Colors.primaryText
                                )
                            }
                            .padding(DesignSystem.Spacing.md)
                            .background(DesignSystem.Colors.cardBackground)
                            .cornerRadius(DesignSystem.CornerRadius.medium)
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                    .stroke(DesignSystem.Colors.yellow.opacity(0.3), lineWidth: 1)
                            )
                        }
                        
                        VStack(spacing: DesignSystem.Spacing.md) {
                            HStack {
                                Image(systemName: "info.circle")
                                    .font(.caption)
                                    .foregroundColor(DesignSystem.Colors.yellow)
                                
                                Text("About")
                                    .font(DesignSystem.Typography.headline)
                                    .foregroundColor(DesignSystem.Colors.primaryText)
                                
                                Spacer()
                            }
                            
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                                InfoRow(
                                    icon: "app.badge",
                                    text: "iOS 16.0 or later required"
                                )
                                
                                InfoRow(
                                    icon: "shield.checkered",
                                    text: "Your data is stored locally on your device"
                                )
                                
                                InfoRow(
                                    icon: "lock.shield",
                                    text: "No data collection or tracking"
                                )
                            }
                            .padding(DesignSystem.Spacing.md)
                            .background(DesignSystem.Colors.cardBackground.opacity(0.5))
                            .cornerRadius(DesignSystem.CornerRadius.medium)
                        }
                        .padding(.top, DesignSystem.Spacing.md)
                    }
                    .padding(.horizontal, DesignSystem.Spacing.lg)
                    .padding(.vertical, DesignSystem.Spacing.xl)
                }
            }
        }
        .alert("Rate Our App", isPresented: $showingRateAlert) {
            Button("Rate Now") {
                requestReview()
            }
            Button("Later", role: .cancel) { }
        } message: {
            Text("If you enjoy using our app, please take a moment to rate it. Your feedback helps us improve!")
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
        } else {
            if let fallbackURL = URL(string: "https://google.com") {
                UIApplication.shared.open(fallbackURL)
            }
        }
    }
    
    private var decisionsThisMonth: Int {
        let calendar = Calendar.current
        let now = Date()
        return viewModel.decisions.filter { decision in
            calendar.isDate(decision.date, equalTo: now, toGranularity: .month)
        }.count
    }
    
    private var averagePerMonth: Double {
        guard !viewModel.decisions.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let sortedDecisions = viewModel.decisions.sorted { $0.date < $1.date }
        
        guard let firstDate = sortedDecisions.first?.date,
              let lastDate = sortedDecisions.last?.date else { return 0 }
        
        let monthsDifference = calendar.dateComponents([.month], from: firstDate, to: lastDate).month ?? 0
        let totalMonths = max(monthsDifference + 1, 1)
        
        return Double(viewModel.decisions.count) / Double(totalMonths)
    }
}

struct StatisticRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 30, height: 30)
                .background(color.opacity(0.2))
                .cornerRadius(DesignSystem.CornerRadius.small)
            
            Text(title)
                .font(DesignSystem.Typography.body)
                .foregroundColor(DesignSystem.Colors.primaryText)
            
            Spacer()
            
            Text(value)
                .font(DesignSystem.Typography.headline)
                .foregroundColor(color)
        }
    }
}

struct InfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: DesignSystem.Spacing.sm) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(DesignSystem.Colors.secondaryText)
                .frame(width: 20)
            
            Text(text)
                .font(DesignSystem.Typography.callout)
                .foregroundColor(DesignSystem.Colors.secondaryText)
            
            Spacer()
        }
    }
}

struct RadialSettingsLayout: View {
    @Binding var rotationAngle: Double
    @Binding var selectedButton: Int?
    @Binding var showingRateAlert: Bool
    
    private struct SettingsItem {
        let icon: String
        let title: String
        let color: Color
    }
    
    private let settingsItems: [SettingsItem] = [
        SettingsItem(icon: "hand.raised.fill", title: "Privacy Policy", color: DesignSystem.Colors.success),
        SettingsItem(icon: "envelope.fill", title: "Contact Us", color: DesignSystem.Colors.warning),
        SettingsItem(icon: "star.fill", title: "Rate App", color: DesignSystem.Colors.yellow)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let radius: CGFloat = min(geometry.size.width, geometry.size.height) * 0.25
            
            ZStack {
                ForEach(0..<settingsItems.count, id: \.self) { index in
                    let angle = Double(index) * 2 * Double.pi / Double(settingsItems.count) - Double.pi / 2
                    let x = center.x + radius * cos(angle)
                    let y = center.y + radius * sin(angle)
                    
                    RadialSettingsButton(
                        icon: settingsItems[index].icon,
                        title: settingsItems[index].title,
                        color: settingsItems[index].color,
                        isSelected: selectedButton == index
                    ) {
                        selectedButton = index
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            selectedButton = nil
                            if index == 2 {
                                showingRateAlert = true
                            } else {
                                if index == 0 {
                                    openURL("https://www.privacypolicies.com/live/b30df6dd-6059-4a47-8ad0-89736af08d02")
                                } else {
                                    openURL("https://www.privacypolicies.com/live/b30df6dd-6059-4a47-8ad0-89736af08d02")
                                }
                            }
                        }
                    }
                    .position(x: x, y: y)
                }
                
                Circle()
                    .stroke(DesignSystem.Colors.yellow.opacity(0.2), lineWidth: 2)
                    .frame(width: radius * 2, height: radius * 2)
                    .position(center)
            }
        }
        .frame(height: 350)
        .onAppear {
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct RadialSettingsButton: View {
    let icon: String
    let title: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                action()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
        }) {
            VStack(spacing: DesignSystem.Spacing.sm) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [color, color.opacity(0.6)],
                                center: .center,
                                startRadius: 0,
                                endRadius: 40
                            )
                        )
                        .frame(width: 70, height: 70)
                        .shadow(color: color.opacity(0.4), radius: 12, x: 0, y: 6)
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [color.opacity(0.8), color.opacity(0.3)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                        .scaleEffect(isPressed || isSelected ? 0.9 : 1.0)
                        .rotationEffect(.degrees(isPressed ? 180 : 0))
                    
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(.black)
                        .scaleEffect(isPressed || isSelected ? 1.1 : 1.0)
                }
                
                Text(title)
                    .font(DesignSystem.Typography.caption)
                    .foregroundColor(DesignSystem.Colors.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(width: 80)
            }
        }
    }
}


#Preview {
    SettingsView()
        .environmentObject(DecisionViewModel())
}
