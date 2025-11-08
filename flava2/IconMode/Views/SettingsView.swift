import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateApp = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                GridBackgroundView()
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerView
                        
                        VStack(spacing: 20) {
                            appSectionView
                            
                            legalSectionView
                            
                            supportSectionView
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Settings")
                    .font(AppFonts.title1)
                    .foregroundColor(AppColors.textPrimary)
                
                Text("App preferences & info")
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "gearshape.fill")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(AppColors.primary)
        }
    }
    
    private var appSectionView: some View {
        VStack(spacing: 0) {
            HStack {
                Text("App")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            
            VStack(spacing: 12) {
                SettingsButton(
                    title: "Rate the App",
                    subtitle: "Help us improve",
                    icon: "star.fill",
                    iconColor: AppColors.accent,
                    isProminent: true
                ) {
                    requestAppReview()
                }
                
            }
        }
    }
    
    private var legalSectionView: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Legal")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            
            VStack(spacing: 12) {
                    SettingsButton(
                        title: "Terms of Use",
                        subtitle: "User agreement",
                        icon: "doc.text",
                        iconColor: AppColors.primary
                    ) {
                        openURL("https://docs.google.com/document/d/1ekAsniSJk1hc7hv-m8Lf73nA0MnI6l4umepwgywzl5k/edit?usp=sharing")
                    }
                
                    
                    SettingsButton(
                        title: "Privacy Policy",
                        subtitle: "Data protection",
                        icon: "lock.shield",
                        iconColor: AppColors.secondary
                    ) {
                        openURL("https://docs.google.com/document/d/13X6E5j24yDg9Sig_dJGwy2hvrWiwdhjfHCe9jljNCOc/edit?usp=sharing")
                    }
            }
        }
    }
    
    private var supportSectionView: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Support")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            
            VStack(spacing: 16) {
                    SettingsButton(
                        title: "Contact Us",
                        subtitle: "Get help & support",
                        icon: "envelope.fill",
                        iconColor: AppColors.warning
                    ) {
                        openURL("https://forms.gle/gaiJ67uMUkRyJzTx5")
                    }
            }
        }
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
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
    let subtitle: String
    let icon: String
    let iconColor: Color
    var isProminent: Bool = false
    var isCompact: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(isProminent ? AppFonts.headline : AppFonts.callout)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text(subtitle)
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(AppColors.textSecondary.opacity(0.5))
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                ZStack {
                    if isProminent {
                        AppColors.buttonGradient.opacity(0.1)
                    } else {
                        AppColors.cardGradient
                    }
                    
                    VStack {
                        HStack {
                            Rectangle()
                                .fill(iconColor.opacity(0.1))
                                .frame(width: 8, height: 8)
                            Spacer()
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            Rectangle()
                                .fill(iconColor.opacity(0.1))
                                .frame(width: 6, height: 6)
                        }
                    }
                }
            )
            .cornerRadius(0)
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(
                        isProminent ? iconColor.opacity(0.4) : AppColors.primary.opacity(0.2),
                        lineWidth: isProminent ? 2 : 1
                    )
            )
            .shadow(
                color: isProminent ? iconColor.opacity(0.2) : Color.clear,
                radius: isProminent ? 8 : 0,
                x: 0,
                y: isProminent ? 4 : 0
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
}
