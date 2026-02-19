import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 12) {
                            SettingsRowView(
                                icon: "doc.text",
                                title: "Terms of Use",
                                action: {
                                    openURL("https://www.termsfeed.com/live/795175bc-d0ba-41ce-9153-0b8ca2b25221")
                                }
                            )
                            
                            SettingsRowView(
                                icon: "hand.raised",
                                title: "Privacy Policy",
                                action: {
                                    openURL("https://www.termsfeed.com/live/e5e3b093-6a5e-4aa7-8ed3-512262be1fdf")
                                }
                            )
                            
                            SettingsRowView(
                                icon: "envelope",
                                title: "Contact Us",
                                action: {
                                    openURL("https://www.termsfeed.com/live/e5e3b093-6a5e-4aa7-8ed3-512262be1fdf")
                                }
                            )
                        }
                        
                        Rectangle()
                            .fill(AppColors.primaryWhite.opacity(0.2))
                            .frame(height: 1)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            SettingsRowView(
                                icon: "star",
                                title: "Rate the App",
                                action: {
                                    requestReview()
                                }
                            )
                        }
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
                .foregroundColor(AppColors.primaryWhite)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsRowView: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppColors.primaryWhite.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.primaryWhite)
                }
                
                Text(title)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.primaryWhite)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.primaryWhite.opacity(0.6))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
        }
    }
}

#Preview {
    SettingsView()
}
