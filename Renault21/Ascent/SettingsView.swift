import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var showingRateAlert = false
    @State private var showingSampleDataLoaded = false
    
    var body: some View {
        ZStack {
            ColorTheme.primaryGradient
                .ignoresSafeArea()
            
            GeometryReader { geo in
                Canvas { context, size in
                    for i in stride(from: 0.0, through: size.width + size.height, by: 40) {
                        let path = Path { p in
                            p.move(to: CGPoint(x: i, y: 0))
                            p.addLine(to: CGPoint(x: i, y: size.height))
                            p.move(to: CGPoint(x: 0, y: i))
                            p.addLine(to: CGPoint(x: size.width, y: i))
                        }
                        context.stroke(path, with: .color(ColorTheme.primaryAccent.opacity(0.04)), lineWidth: 0.5)
                    }
                }
            }
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    
                    VStack(spacing: 12) {
                        SettingsRow(
                            icon: "shield.fill",
                            iconColor: ColorTheme.primaryAccent,
                            title: "Privacy Policy",
                            subtitle: "Data protection and your privacy"
                        ) {
                            viewModel.openPrivacyPolicy()
                        }
                        
                        SettingsRow(
                            icon: "envelope.fill",
                            iconColor: ColorTheme.success,
                            title: "Contact Us",
                            subtitle: "Get in touch with support"
                        ) {
                            viewModel.openContactEmail()
                        }
                        
                        SettingsRow(
                            icon: "star.fill",
                            iconColor: ColorTheme.warning,
                            title: "Rate the App",
                            subtitle: "Share your experience on the App Store"
                        ) {
                            showingRateAlert = true
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    
                    VStack(spacing: 8) {
                        Text("IronPlan")
                            .font(FontManager.playfairSemiBold(size: 14))
                            .foregroundColor(ColorTheme.secondaryText)
                        
                        Text("Your Fitness Companion")
                            .font(FontManager.playfairRegular(size: 12))
                            .foregroundColor(ColorTheme.tertiaryText)
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 100)
                }
                .padding(.bottom, 30)
            }
        }
        .alert("Rate IronPlan", isPresented: $showingRateAlert) {
            Button("Not Now", role: .cancel) { }
            Button("Rate App") {
                viewModel.requestAppReview()
            }
        } message: {
            Text("Enjoying IronPlan? Please take a moment to rate us on the App Store!")
        }
        .alert("Sample Data Loaded", isPresented: $showingSampleDataLoaded) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Sample workouts, nutrition items, tasks and progress have been loaded. Check Today, My Items, Statistics and History.")
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 20) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [
                                    ColorTheme.primaryAccent,
                                    ColorTheme.primaryAccent.opacity(0.8)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 64, height: 64)
                        .shadow(color: ColorTheme.primaryAccent.opacity(0.4), radius: 12, x: 0, y: 6)
                    
                    Image(systemName: "gearshape.2.fill")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(ColorTheme.primaryText)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Settings")
                        .font(FontManager.playfairBold(size: 26))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text("Privacy, support and more")
                        .font(FontManager.playfairRegular(size: 15))
                        .foregroundColor(ColorTheme.secondaryText)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 8)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                    isPressed = false
                }
                action()
            }
        }) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(FontManager.playfairSemiBold(size: 17))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text(subtitle)
                        .font(FontManager.playfairRegular(size: 13))
                        .foregroundColor(ColorTheme.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(ColorTheme.primaryAccent.opacity(0.8))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(ColorTheme.cardBorder, lineWidth: 1)
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
    }
}

#Preview {
    SettingsView()
}
