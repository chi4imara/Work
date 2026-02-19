import SwiftUI
import StoreKit
import CoreGraphics

struct SettingsView: View {
    @State private var showingRateApp = false
    @State private var showingSampleDataAlert = false
    
    var onLoadSampleData: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    headerView
                    
                    VStack(spacing: AppSpacing.md) {
                        SettingsSection(title: "App") {
                            SettingsRow(
                                title: "Rate the App",
                                icon: "star",
                                iconColor: AppColors.iconAccent,
                                action: { requestAppReview() }
                            )
                        }
                        
                        SettingsSection(title: "Legal") {
                            SettingsRow(
                                title: "Privacy Policy",
                                icon: "hand.raised",
                                iconColor: AppColors.lightGreen,
                                action: { openPrivacyPolicy() }
                            )
                        }
                        
                        SettingsSection(title: "Support") {
                            SettingsRow(
                                title: "Contact Us",
                                icon: "envelope",
                                iconColor: AppColors.softPink,
                                action: { openContactEmail() }
                            )
                        }
                        
                        aboutSection
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.bottom, 120)
            }
        }
        .alert("Load Sample Data?", isPresented: $showingSampleDataAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Load") {
                onLoadSampleData?()
            }
        } message: {
            Text("This will replace current data with sample data for testing. Your existing data will be overwritten.")
        }
    }
    
    private var headerView: some View {
        VStack(spacing: AppSpacing.md) {
            ZStack {
                Circle()
                    .fill(AppColors.primaryYellow.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "bolt.heart")
                    .font(.system(size: 36, weight: .medium))
                    .foregroundColor(AppColors.iconAccent)
            }
            
            VStack(spacing: AppSpacing.xs) {
                Text("Energy Health")
                    .font(AppFonts.title2())
                    .foregroundColor(AppColors.textPrimary)
            }
        }
        .padding(.top, AppSpacing.lg)
    }
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("About")
                .font(AppFonts.headline())
                .foregroundColor(AppColors.textPrimary)
                .padding(.horizontal, AppSpacing.sm)
            
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Energy Health helps you build healthy habits and track your daily wellness journey.")
                    .font(AppFonts.body())
                    .foregroundColor(AppColors.textSecondary)
                
                Text("Take small steps every day towards a healthier, more energized you.")
                    .font(AppFonts.callout())
                    .foregroundColor(AppColors.textTertiary)
                    .italic()
            }
            .padding(AppSpacing.md)
            .frame(maxWidth: .infinity)
            .background(AppColors.cardBackground)
            .cornerRadius(AppCornerRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.md)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
        }
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func openPrivacyPolicy() {
        if let url = URL(string: "https://doc-hosting.flycricket.io/wellnessgarden-energy-privacy-policy/507153eb-7872-4b2b-8872-789ac2517455/privacy") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openContactEmail() {
        if let url = URL(string: "https://forms.gle/vssNEKBqDV4Su1gm7") {
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
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(title)
                .font(AppFonts.headline())
                .foregroundColor(AppColors.textPrimary)
                .padding(.horizontal, AppSpacing.sm)
            
            VStack(spacing: 1) {
                content
            }
            .background(AppColors.cardBackground)
            .cornerRadius(AppCornerRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.md)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
        }
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    let iconColor: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.iconPrimary)
                }
                
                Text(title)
                    .font(AppFonts.body())
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.textTertiary)
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
            .background(
                isPressed ? AppColors.cardBackground.opacity(0.5) : Color.clear
            )
            .contentShape(Rectangle())
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct CreativeSettingsGrid: View {
    let items: [SettingsGridItem]
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: AppSpacing.sm),
            GridItem(.flexible(), spacing: AppSpacing.sm)
        ], spacing: AppSpacing.sm) {
            ForEach(items) { item in
                CreativeSettingsCard(item: item)
            }
        }
    }
}

struct CreativeSettingsCard: View {
    let item: SettingsGridItem
    @State private var isHovered = false
    
    var body: some View {
        Button(action: item.action) {
            VStack(spacing: AppSpacing.sm) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppCornerRadius.md)
                        .fill(item.color.opacity(0.1))
                        .frame(height: 60)
                        .scaleEffect(isHovered ? 1.05 : 1.0)
                    
                    Image(systemName: item.icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(item.color)
                        .offset(y: isHovered ? -2 : 0)
                }
                
                VStack(spacing: 2) {
                    Text(item.title)
                        .font(AppFonts.callout())
                        .foregroundColor(AppColors.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    if let subtitle = item.subtitle {
                        Text(subtitle)
                            .font(AppFonts.caption2())
                            .foregroundColor(AppColors.textTertiary)
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .padding(AppSpacing.sm)
            .background(AppColors.cardBackground)
            .cornerRadius(AppCornerRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.md)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
            .scaleEffect(isHovered ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isHovered = hovering
            }
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isHovered = pressing
            }
        }, perform: {})
    }
}

struct SettingsGridItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String?
    let icon: String
    let color: Color
    let action: () -> Void
}

struct FloatingSettingsMenu: View {
    let items: [SettingsGridItem]
    
    var body: some View {
        ZStack {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                FloatingSettingsButton(item: item, index: index)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 200)
    }
}

struct FloatingSettingsButton: View {
    let item: SettingsGridItem
    let index: Int
    @State private var isVisible = false
    
    private var position: CGPoint {
        let angle = Double(index) * (2 * .pi / 6) 
        let radius: CGFloat = 80
        return CGPoint(
            x: cos(angle) * radius,
            y: sin(angle) * radius
        )
    }
    
    var body: some View {
        Button(action: item.action) {
            VStack(spacing: AppSpacing.xs) {
                ZStack {
                    Circle()
                        .fill(item.color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: item.icon)
                        .font(.system(size: 20))
                        .foregroundColor(item.color)
                }
                
                Text(item.title)
                    .font(AppFonts.caption2())
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
            }
        }
        .offset(x: isVisible ? position.x : 0, y: isVisible ? position.y : 0)
        .opacity(isVisible ? 1 : 0)
        .scaleEffect(isVisible ? 1 : 0.5)
        .animation(
            .spring(response: 0.6, dampingFraction: 0.8)
                .delay(Double(index) * 0.1),
            value: isVisible
        )
        .onAppear {
            withAnimation {
                isVisible = true
            }
        }
    }
}

#Preview {
    SettingsView()
}
