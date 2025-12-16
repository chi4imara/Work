import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        ZStack {
            AppGradients.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    headerView
                    
                    VStack(spacing: 24) {
                        appSection
                        
                        legalSection
                        
                        contactSection
                    }
                    .padding(.top, 30)
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
    }
    
    private var headerView: some View {
        Text("Settings")
            .font(.builderSans(size: 24, weight: .bold))
            .foregroundColor(.primaryText)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var appSection: some View {
        SettingsSection(title: "App") {
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "star",
                    title: "Rate App",
                    iconColor: .accentYellow
                ) {
                    settingsViewModel.requestAppReview()
                }
            }
        }
    }
    
    private var legalSection: some View {
        SettingsSection(title: "Legal") {
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "doc.text",
                    title: "Terms of Use",
                    iconColor: .primaryText
                ) {
                    settingsViewModel.openURL("https://www.termsfeed.com/live/868e0896-a4dc-4cf7-aa68-84a97692cb4c")
                }
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsRow(
                    icon: "lock.shield",
                    title: "Privacy Policy",
                    iconColor: .primaryText
                ) {
                    settingsViewModel.openURL("https://www.termsfeed.com/live/5b832dc7-9f1f-45e0-9eac-b4ba025a1880")
                }
            }
        }
    }
    
    private var contactSection: some View {
        SettingsSection(title: "Contact") {
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "envelope",
                    title: "Contact Us",
                    iconColor: .lightOrange
                ) {
                    settingsViewModel.openURL("https://www.termsfeed.com/live/5b832dc7-9f1f-45e0-9eac-b4ba025a1880")
                }
            }
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
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.builderSans(size: 18, weight: .semibold))
                .foregroundColor(.primaryText)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                content
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppGradients.cardGradient)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(iconColor)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.builderSans(size: 16, weight: .medium))
                    .foregroundColor(.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondaryText)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView(settingsViewModel: SettingsViewModel())
}
