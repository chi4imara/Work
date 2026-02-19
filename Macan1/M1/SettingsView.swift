import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 24) {
                        appInfoSection
                        
                        legalSection
                        
                        supportSection
                        
                        ratingSection
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
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Image(systemName: "gearshape.2")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(AppColors.primaryYellow)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(AppColors.primaryYellow)
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "paintbrush.pointed.fill")
                        .font(.system(size: 35, weight: .medium))
                        .foregroundColor(AppColors.backgroundGradientStart)
                }
                
                VStack(spacing: 4) {
                    Text("Cosmetic Catalog")
                        .font(.ubuntu(20, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                }
            }
            .padding(.vertical, 20)
        }
        .frame(maxWidth: .infinity)
        .background(AppColors.cardBackground)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
    
    private var legalSection: some View {
        VStack(spacing: 24) {
            SettingsButton(
                title: "Terms of Use",
                icon: "doc.text",
                style: .primary
            ) {
                openURL("https://www.privacypolicies.com/live/ff77cfe0-46ed-440d-a1d9-aa48f53b21ea")
            }
            
            SettingsButton(
                title: "Privacy Policy",
                icon: "lock.shield",
                style: .secondary,
                isCompact: true
            ) {
                openURL("https://www.privacypolicies.com/live/d00a4d95-0eef-48fd-9fbb-40a1600d92d0")
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
    
    private var supportSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "envelope")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.accentOrange)
                
                Text("Support")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            
            Button(action: { openURL("https://www.privacypolicies.com/live/d00a4d95-0eef-48fd-9fbb-40a1600d92d0") }) {
                ZStack {
                    Circle()
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                        .frame(width: 120, height: 120)
                    
                    VStack(spacing: 4) {
                        Image(systemName: "envelope.circle.fill")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(AppColors.accentOrange)
                        
                        Text("Contact Us")
                            .font(.ubuntu(12, weight: .medium))
                            .foregroundColor(AppColors.textPrimary)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
    
    private var ratingSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "star.circle")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.primaryYellow)
                
                Text("Rate Our App")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                Text("Enjoying the app? Help us by leaving a review!")
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 8) {
                    ForEach(1...5, id: \.self) { star in
                        Button(action: { requestReview() }) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(AppColors.primaryYellow)
                                .scaleEffect(star == 3 ? 1.2 : 1.0)
                        }
                    }
                }
                
                Button(action: { requestReview() }) {
                    Text("Rate App")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.backgroundGradientStart)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(AppColors.primaryYellow)
                        .cornerRadius(20)
                }
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppColors.primaryYellow.opacity(0.3), lineWidth: 1)
        )
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsButton: View {
    let title: String
    let icon: String
    let style: ButtonStyle
    let isCompact: Bool
    let action: () -> Void
    
    enum ButtonStyle {
        case primary, secondary, accent
        
        var backgroundColor: Color {
            switch self {
            case .primary:
                return AppColors.primaryYellow
            case .secondary:
                return AppColors.accentPurple
            case .accent:
                return AppColors.accentOrange
            }
        }
        
        var foregroundColor: Color {
            return AppColors.backgroundGradientStart
        }
    }
    
    init(title: String, icon: String, style: ButtonStyle, isCompact: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.style = style
        self.isCompact = isCompact
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color.white)
                
                Text(title)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(Color.yellow)
            .cornerRadius(16)
        }
    }
}

#Preview {
    SettingsView()
}
