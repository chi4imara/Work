import SwiftUI

struct SettingsView: View {
    @ObservedObject var appViewModel: AppViewModel
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Settings")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerSection
                        legalSection
                        supportSection
                    }
                    .padding(20)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "waterbottle.fill")
                .font(.system(size: 60))
                .foregroundColor(AppColors.accentYellow)
            
            Text("Fragrance Collection")
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Text("Organize your scent journey")
                .font(.ubuntu(16))
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(.vertical, 20)
    }
    
    private var legalSection: some View {
        SettingsSection(title: "Legal") {
            VStack(spacing: 12) {
                SettingsRow(
                    title: "Terms of Use",
                    icon: "doc.text",
                    action: { openURL("https://www.termsfeed.com/live/7d6f8fc1-ef82-46f7-80c7-b8ad5ce9a743") }
                )
                
                SettingsRow(
                    title: "Privacy Policy",
                    icon: "lock.shield",
                    action: { openURL("https://www.termsfeed.com/live/188e6b97-9e9b-4156-9ae7-7814c448dc3d") }
                )
            }
        }
    }
    
    private var supportSection: some View {
        SettingsSection(title: "Support") {
            VStack(spacing: 12) {
                SettingsRow(
                    title: "Contact Us",
                    icon: "envelope",
                    action: { openURL("https://www.termsfeed.com/live/188e6b97-9e9b-4156-9ae7-7814c448dc3d") }
                )
                
                SettingsRow(
                    title: "Rate App",
                    icon: "star",
                    action: { appViewModel.requestAppReview() }
                )
            }
        }
    }
    
    private var aboutSection: some View {
        SettingsSection(title: "About") {
            VStack(spacing: 16) {
                HStack {
                    Text("Version")
                        .font(.ubuntu(16))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Text("1.0.0")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Text("Built with love for fragrance enthusiasts")
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.tertiaryText)
                    .multilineTextAlignment(.center)
                    .italic()
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(AppColors.accentYellow)
                    .frame(width: 24)
                
                Text(title)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.tertiaryText)
            }
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    SettingsView(appViewModel: AppViewModel())
}
