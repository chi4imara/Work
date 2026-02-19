import SwiftUI
import StoreKit

struct SettingsView: View {
    @StateObject private var settingsViewModel = SettingsViewModel()
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                HStack {
                    Text("Settings")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(AppColors.white)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(AppColors.cardGradient)
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "scissors")
                                    .font(.system(size: 35, weight: .light))
                                    .foregroundColor(AppColors.orange)
                            }
                            
                            Text("Beard Care Journal")
                                .font(.ubuntu(20, weight: .bold))
                                .foregroundColor(AppColors.white)
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 20) {
                            
                            SettingsButton(
                                title: "Privacy Policy",
                                icon: "shield.checkered",
                                color: AppColors.lightBlue
                            ) {
                                settingsViewModel.openPrivacyPolicy()
                            }
                            
                            SettingsButton(
                                title: "Contact Us",
                                icon: "envelope",
                                color: AppColors.green
                            ) {
                                settingsViewModel.openContactEmail()
                            }
                            
                        }
                        .padding(.horizontal, 20)
                        
                        SettingsButton(
                            title: "Rate App",
                            icon: "star.fill",
                            color: AppColors.orange
                        ) {
                            requestReview()
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
    }
}

struct SettingsButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(AppColors.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
            )
        }
    }
}
