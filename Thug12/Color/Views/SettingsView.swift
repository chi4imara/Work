import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var appState: AppStateManager
    @State private var animateSettings = false
    @Environment(\.requestReview) private var requestReview
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: AppSpacing.xl) {
                        appSectionView
                        
                        legalSectionView
                        
                        contactSectionView
                        
                        appInfoView
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.vertical, AppSpacing.md)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6)) {
                animateSettings = true
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(AppFonts.largeTitle)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.top, AppSpacing.md)
    }
    
    private var appSectionView: some View {
        VStack(spacing: AppSpacing.md) {
            SectionHeader(title: "App")
            
            VStack(spacing: AppSpacing.xs) {
                SettingsRow(
                    title: "Rate App",
                    icon: "star.fill",
                    iconColor: AppColors.accentYellow
                ) {
                    requestReview()
                }
                .opacity(animateSettings ? 1.0 : 0.0)
                .offset(x: animateSettings ? 0 : -50)
                .animation(.easeInOut(duration: 0.5).delay(0.1), value: animateSettings)
            }
        }
    }
    
    private var legalSectionView: some View {
        VStack(spacing: AppSpacing.md) {
            SectionHeader(title: "Legal")
            
            VStack(spacing: AppSpacing.xs) {
                SettingsRow(
                    title: "Terms and Conditions",
                    icon: "doc.text",
                    iconColor: AppColors.primaryOrange
                ) {
                    openURL("https://docs.google.com/document/d/165BFRFfDI5cT319vIVNRS4W-8XZtUTiJNB4-hvEh-uk/edit?usp=sharing")
                }
                .opacity(animateSettings ? 1.0 : 0.0)
                .offset(x: animateSettings ? 0 : -50)
                .animation(.easeInOut(duration: 0.5).delay(0.2), value: animateSettings)
                
                Divider()
                    .background(AppColors.primaryText.opacity(0.2))
                
                SettingsRow(
                    title: "Privacy Policy",
                    icon: "hand.raised.fill",
                    iconColor: AppColors.info
                ) {
                    openURL("https://docs.google.com/document/d/1fgK1oxY47bKE33pGurLkTlG-rtTfbyIZsp4OGHcbssQ/edit?usp=sharing")
                }
                .opacity(animateSettings ? 1.0 : 0.0)
                .offset(x: animateSettings ? 0 : -50)
                .animation(.easeInOut(duration: 0.5).delay(0.3), value: animateSettings)
            }
        }
    }
    
    private var contactSectionView: some View {
        VStack(spacing: AppSpacing.md) {
            SectionHeader(title: "Contact")
            
            VStack(spacing: AppSpacing.xs) {
                SettingsRow(
                    title: "Contact Us",
                    icon: "envelope.fill",
                    iconColor: AppColors.success
                ) {
                    openURL("https://forms.gle/gzx3hHYXnAPx5fv2A")
                }
                .opacity(animateSettings ? 1.0 : 0.0)
                .offset(x: animateSettings ? 0 : -50)
                .animation(.easeInOut(duration: 0.5).delay(0.4), value: animateSettings)
            }
        }
    }
    
    private var appInfoView: some View {
        VStack(spacing: AppSpacing.sm) {
            Text("Weather Colors")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)
            
            Text("Track your weather with colors")
                .font(AppFonts.caption)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, AppSpacing.lg)
        .opacity(animateSettings ? 1.0 : 0.0)
        .animation(.easeInOut(duration: 0.6).delay(0.5), value: animateSettings)
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(AppFonts.title2)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppCornerRadius.small)
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(AppSpacing.md)
            .background(AppColors.cardGradient)
            .cornerRadius(AppCornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                    .stroke(AppColors.primaryText.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView(appState: AppStateManager())
}
