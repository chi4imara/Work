import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        ZStack {
            Color.theme.primaryGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("Settings")
                            .font(.playfairDisplay(size: 28, weight: .bold))
                            .foregroundColor(Color.theme.primaryText)
                        
                        Text("App preferences and information")
                            .font(.playfairDisplay(size: 14))
                            .foregroundColor(Color.theme.secondaryText)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        SettingsSection(title: "App") {
                            VStack(spacing: 12) {
                                SettingsButton(
                                    icon: "star.fill",
                                    title: "Rate App",
                                    subtitle: "Help us improve",
                                    iconColor: Color.theme.orange
                                ) {
                                    settingsViewModel.requestReview()
                                }
                            }
                        }
                        
                        SettingsSection(title: "Support") {
                            VStack(spacing: 12) {
                                SettingsButton(
                                    icon: "envelope.fill",
                                    title: "Contact Us",
                                    subtitle: "Get in touch",
                                    iconColor: Color.theme.lightBlue
                                ) {
                                    settingsViewModel.openContactEmail()
                                }
                            }
                        }
                        
                        SettingsSection(title: "Legal") {
                            VStack(spacing: 12) {
                                SettingsButton(
                                    icon: "doc.text.fill",
                                    title: "Privacy Policy",
                                    subtitle: "How we handle your data",
                                    iconColor: Color.theme.mediumGray
                                ) {
                                    settingsViewModel.openPrivacyPolicy()
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 120)
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
                .font(.playfairDisplay(size: 18, weight: .semibold))
                .foregroundColor(Color.theme.primaryText)
                .padding(.horizontal, 4)
            
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SettingsButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.playfairDisplay(size: 16, weight: .medium))
                        .foregroundColor(Color.theme.primaryText)
                        .multilineTextAlignment(.leading)
                    
                    Text(subtitle)
                        .font(.playfairDisplay(size: 12))
                        .foregroundColor(Color.theme.secondaryText)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.theme.mediumGray)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.theme.cardBackground)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.theme.lightBlue.opacity(0.3), lineWidth: 1)
                    }
            )
        }
    }
}

struct CreativeSettingsView: View {
    @ObservedObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        ZStack {
            Color.theme.primaryGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.theme.lightBlue.opacity(0.2))
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: "gearshape.2.fill")
                                .font(.system(size: 32))
                                .foregroundColor(Color.theme.lightBlue)
                        }
                        
                        Text("Settings")
                            .font(.playfairDisplay(size: 28, weight: .bold))
                            .foregroundColor(Color.theme.primaryText)
                    }
                    .padding(.top, 20)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ], spacing: 16) {
                        
                        CreativeSettingsCard(
                            icon: "star.fill",
                            title: "Rate App",
                            subtitle: "Love it? Rate us!",
                            gradient: LinearGradient(
                                colors: [Color.theme.orange, Color.theme.orange.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        ) {
                            settingsViewModel.requestReview()
                        }
                        
                        CreativeSettingsCard(
                            icon: "envelope.fill",
                            title: "Contact",
                            subtitle: "Get in touch",
                            gradient: LinearGradient(
                                colors: [Color.theme.lightBlue, Color.theme.lightBlue.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        ) {
                            settingsViewModel.openContactEmail()
                        }
                        
                        CreativeSettingsCard(
                            icon: "doc.text.fill",
                            title: "Privacy",
                            subtitle: "Your data matters",
                            gradient: LinearGradient(
                                colors: [Color.theme.mediumGray, Color.theme.darkGray],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        ) {
                            settingsViewModel.openPrivacyPolicy()
                        }
                        
                        CreativeSettingsCard(
                            icon: "info.circle.fill",
                            title: "About",
                            subtitle: "",
                            gradient: LinearGradient(
                                colors: [Color.theme.darkBlue, Color.theme.darkBlue.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        ) {
                            
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
    }
}

struct CreativeSettingsCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let gradient: LinearGradient
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.playfairDisplay(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.playfairDisplay(size: 11))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
            }
            .frame(height: 120)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(gradient)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView(settingsViewModel: SettingsViewModel())
}

#Preview("Creative Layout") {
    CreativeSettingsView(settingsViewModel: SettingsViewModel())
}
