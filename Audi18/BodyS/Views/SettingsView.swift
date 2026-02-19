import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Settings")
                        .font(.bellGothic(size: 28, weight: .bold))
                        .foregroundColor(AppColors.primaryBlue)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 16) {
                            VStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(AppColors.cardGradient)
                                        .frame(width: 80, height: 80)
                                        .shadow(color: AppColors.primaryBlue.opacity(0.2), radius: 8, x: 0, y: 4)
                                    
                                    Image(systemName: "list.clipboard")
                                        .font(.system(size: 35))
                                        .foregroundColor(AppColors.primaryBlue)
                                }
                                
                                Text("Care Routine")
                                    .font(.bellGothic(size: 20, weight: .bold))
                                    .foregroundColor(AppColors.primaryBlue)
                            }
                            .padding(.vertical, 20)
                        }
                        
                        VStack(spacing: 16) {
                            HStack(spacing: 16) {
                                SettingsOptionView(
                                    icon: "shield.checkered",
                                    title: "Privacy Policy",
                                    subtitle: "Data protection",
                                    color: AppColors.softGreen,
                                    action: {
                                        openURL("https://doc-hosting.flycricket.io/body-syntax-privacy-policy/09ae1a04-f459-4b8c-8829-b1cd720ad93b/privacy")
                                    }
                                )
                                
                                SettingsOptionView(
                                    icon: "star.fill",
                                    title: "Rate App",
                                    subtitle: "Leave a review",
                                    color: AppColors.primaryYellow,
                                    action: {
                                        requestReview()
                                    }
                                )
                            }
                            
                            SettingsOptionView(
                                icon: "envelope.fill",
                                title: "Contact Us",
                                subtitle: "Get in touch for support or feedback",
                                color: AppColors.primaryBlue,
                                isFullWidth: true,
                                action: {
                                    openURL("https://forms.gle/Lyt9rWpVpG63GSEH6")
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 30)
                }
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsOptionView: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    var isFullWidth: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(color)
                        .clipShape(Circle())
                    
                    if !isFullWidth {
                        Spacer()
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.bellGothic(size: 16, weight: .bold))
                        .foregroundColor(AppColors.primaryBlue)
                    
                    Text(subtitle)
                        .font(.bellGothic(size: 12))
                        .foregroundColor(AppColors.darkGray)
                        .lineLimit(2)
                }
                
                if !isFullWidth {
                    Spacer()
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: isFullWidth ? 100 : 120)
            .background(AppColors.cardGradient)
            .cornerRadius(16)
            .shadow(color: color.opacity(0.2), radius: 6, x: 0, y: 3)
        }
    }
}

struct SmallSettingsOptionView: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(color)
                    .clipShape(Circle())
                
                Text(title)
                    .font(.bellGothic(size: 14, weight: .bold))
                    .foregroundColor(AppColors.primaryBlue)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(AppColors.cardGradient)
            .cornerRadius(12)
            .shadow(color: color.opacity(0.15), radius: 4, x: 0, y: 2)
        }
    }
}
