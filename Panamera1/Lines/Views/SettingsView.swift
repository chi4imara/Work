import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Settings")
                        .font(.bellGothicBold(size: 24))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(AppColors.cardGradient)
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Image(systemName: "drop.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(AppColors.primaryYellow)
                                )
                            
                            Text("Fragrance Journal")
                                .font(.bellGothicBold(size: 24))
                                .foregroundColor(AppColors.textPrimary)
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(AppColors.cardGradient)
                                .shadow(color: AppColors.shadowColor, radius: 6, x: 0, y: 3)
                        )
                        
                        VStack(spacing: 16) {
                            Text("Settings")
                                .font(.bellGothicBold(size: 20))
                                .foregroundColor(AppColors.textPrimary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(spacing: 12) {
                                SettingsRowView(
                                    title: "Privacy Policy",
                                    icon: "lock.shield",
                                    action: {
                                        openURL("https://www.privacypolicies.com/live/92cdb09a-4184-4cbd-a72b-d85d55dbff55")
                                    }
                                )
                                
                                SettingsRowView(
                                    title: "Contact Us",
                                    icon: "envelope",
                                    action: {
                                        openURL("https://www.privacypolicies.com/live/92cdb09a-4184-4cbd-a72b-d85d55dbff55")
                                    }
                                )
                                
                                SettingsRowView(
                                    title: "Rate App",
                                    icon: "star",
                                    action: {
                                        requestReview()
                                    }
                                )
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(AppColors.cardGradient)
                                .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
                        )
                        
                        VStack(spacing: 12) {
                            Text("About")
                                .font(.bellGothicBold(size: 20))
                                .foregroundColor(AppColors.textPrimary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("Capture every perfume impression and build your personal fragrance collection. Rate, organize, and explore your favorite scents with ease.")
                                .font(.bellGothicRegular(size: 16))
                                .foregroundColor(AppColors.textSecondary)
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(AppColors.cardGradient)
                                .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}

struct SettingsRowView: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(AppColors.primaryYellow)
                    .font(.title3)
                    .frame(width: 24)
                
                Text(title)
                    .font(.bellGothicRegular(size: 18))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(AppColors.textSecondary)
                    .font(.caption)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.buttonSecondary)
            )
        }
    }
}

#Preview {
    SettingsView()
}
