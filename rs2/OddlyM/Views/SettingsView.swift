import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showRateAlert = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Settings")
                        .font(.appTitle())
                        .foregroundColor(AppColors.textWhite)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 20) {
                            SettingsButton(
                                title: "Privacy Policy",
                                icon: "lock.shield",
                                action: {
                                    openURL("https://doc-hosting.flycricket.io/oddlyme-privacy-policy/a44b731e-7895-4081-bb9d-75ac39455a82/privacy")
                                }
                            )
                            
                            SettingsButton(
                                title: "Contact Email",
                                icon: "envelope",
                                action: {
                                    openURL("https://forms.gle/NrzRtGR7mY9ctJeP9")
                                }
                            )
                            
                            SettingsButton(
                                title: "Rate App",
                                icon: "star",
                                action: {
                                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                        SKStoreReviewController.requestReview(in: windowScene)
                                    }
                                }
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Tips")
                                .font(.appHeadline())
                                .foregroundColor(AppColors.textWhite)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                TipCard(
                                    icon: "lightbulb",
                                    title: "Track Daily",
                                    description: "Mark your rituals daily to see meaningful patterns emerge over time."
                                )
                                
                                TipCard(
                                    icon: "chart.bar",
                                    title: "Review Statistics",
                                    description: "Check your statistics regularly to understand your ritual frequency."
                                )
                                
                                TipCard(
                                    icon: "calendar",
                                    title: "Use Calendar",
                                    description: "View your ritual completion history in the calendar view."
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        Text("Made with care for tracking your unique rituals")
                            .font(.appCaption())
                            .foregroundColor(AppColors.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                            .padding(.top, 10)
                            .padding(.bottom, 30)
                    }
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

struct SettingsButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.accentPurple)
                    .frame(width: 30)
                
                Text(title)
                    .font(.appBody())
                    .foregroundColor(AppColors.textWhite)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding()
            .background(AppColors.cardBackground)
            .cornerRadius(12)
        }
    }
}

struct InfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(AppColors.accentPurple)
                .frame(width: 24)
            
            Text(text)
                .font(.appBody())
                .foregroundColor(AppColors.textWhite)
            
            Spacer()
        }
    }
}

struct TipCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(AppColors.accentPurple)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.appHeadline())
                    .foregroundColor(AppColors.textWhite)
                
                Text(description)
                    .font(.appCaption())
                    .foregroundColor(AppColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(12)
    }
}
