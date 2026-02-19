import SwiftUI
import StoreKit

struct SettingsView: View {
    @EnvironmentObject var viewModel: DailyEntryViewModel
    
    var body: some View {
        ZStack {
            AppBackgroundView()
            
            ScrollView {
                VStack(spacing: 0) {
                    VStack(spacing: 8) {
                        Text("Settings")
                            .font(AppFonts.playfairBold(size: 28))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("Customize your experience")
                            .font(AppFonts.playfairRegular(size: 16))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 28)
                    
                    VStack(spacing: 0) {
                        SettingRowView(
                            title: "Privacy Policy",
                            subtitle: "Data protection",
                            icon: "shield.fill",
                            accent: AppColors.softPink
                        ) {
                            if let url = URL(string: "https://www.termsfeed.com/live/df8ac172-869f-4193-a5b7-fa2860721901") {
                                UIApplication.shared.open(url)
                            }
                        }
                        
                        Divider()
                            .background(AppColors.primaryText.opacity(0.15))
                            .padding(.leading, 72)
                        
                        SettingRowView(
                            title: "Contact Us",
                            subtitle: "Email and support",
                            icon: "envelope.fill",
                            accent: AppColors.lightGreen
                        ) {
                            if let url = URL(string: "https://www.termsfeed.com/live/df8ac172-869f-4193-a5b7-fa2860721901") {
                                UIApplication.shared.open(url)
                            }
                        }
                        
                        Divider()
                            .background(AppColors.primaryText.opacity(0.15))
                            .padding(.leading, 72)
                        
                        SettingRowView(
                            title: "Rate App",
                            subtitle: "Leave a review",
                            icon: "star.fill",
                            accent: AppColors.lavender
                        ) {
                            requestReview()
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.06))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 20)
                }
            }
        }
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingRowView: View {
    let title: String
    let subtitle: String
    let icon: String
    let accent: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(accent.opacity(0.25))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color.white)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(AppFonts.playfairSemiBold(size: 17))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(subtitle)
                        .font(AppFonts.playfairRegular(size: 13))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(accent.opacity(0.9))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

struct SettingRowButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct WebView: View {
    let url: String
    let title: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AppBackgroundView()
                
                VStack(spacing: 30) {
                    Image(systemName: "safari")
                        .font(.system(size: 60))
                        .foregroundColor(AppColors.accentYellow)
                    
                    VStack(spacing: 15) {
                        Text("Opening in Browser")
                            .font(AppFonts.playfairBold(size: 24))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("This will open \(title.lowercased()) in your default web browser.")
                            .font(AppFonts.playfairRegular(size: 16))
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button("Open Browser") {
                        if let url = URL(string: url) {
                            UIApplication.shared.open(url)
                        }
                        dismiss()
                    }
                    .font(AppFonts.playfairSemiBold(size: 18))
                    .foregroundColor(AppColors.primaryBlue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(AppColors.accentYellow)
                    .cornerRadius(28)
                    .padding(.horizontal, 40)
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
            }
        }
    }
}
