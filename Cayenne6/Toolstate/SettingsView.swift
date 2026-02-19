import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Settings")
                    .font(.ubuntu(32, weight: .bold))
                    .foregroundColor(AppColors.white)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Image(systemName: "wrench.and.screwdriver")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(AppColors.lightBlue)
                            .frame(width: 100, height: 100)
                            .background(
                                Circle()
                                    .fill(AppColors.cardBackground)
                            )
                        
                        VStack(spacing: 4) {
                            Text("Garage Organizer")
                                .font(.ubuntu(20, weight: .bold))
                                .foregroundColor(AppColors.white)
                        }
                    }
                    .padding(.top, 20)
                    
                    SettingsRow(
                        icon: "shield.checkered",
                        title: "Privacy Policy",
                        action: {
                            if let url = URL(string: "https://www.privacypolicies.com/live/46c2e80a-2097-4eac-b641-b2a84557e791") {
                                UIApplication.shared.open(url)
                            }
                        }
                    )
                    
                    SettingsRow(
                        icon: "envelope",
                        title: "Contact Us",
                        action: {
                            if let url = URL(string: "https://www.privacypolicies.com/live/46c2e80a-2097-4eac-b641-b2a84557e791") {
                                UIApplication.shared.open(url)
                            }
                        }
                    )
                    
                    SettingsRow(
                        icon: "star",
                        title: "Rate App",
                        action: {
                            viewModel.requestAppReview()
                        }
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 120)
            }
        }
    }
}

struct SettingsButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(color)
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.white)
                        .multilineTextAlignment(.center)
                    
                    Text(subtitle)
                        .font(.ubuntu(10))
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardBackground)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.lightBlue)
                    .frame(width: 24)
                
                Text(title)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
            )
        }
    }
}
