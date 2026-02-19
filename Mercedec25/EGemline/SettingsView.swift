import SwiftUI
import StoreKit

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @State private var showPrivacyPolicy = false
    @State private var showContactSheet = false
    @State private var showSampleDataLoaded = false
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            GridPatternView()
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    headerSection
                    
                    notificationsSection
                    
                    appActionsSection
                    
                    supportSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 120)
            }
        }
        .alert("Sample Data Loaded", isPresented: $showSampleDataLoaded) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Sample jewelry and try-on sessions have been added. Check Home and Progress tabs.")
        }
    }
    
    private var headerSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Settings")
                    .font(.playfairDisplay(28, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Customize your experience")
                    .font(.playfairDisplay(15, weight: .medium))
                    .foregroundColor(ColorTheme.secondaryText)
            }
            
            Spacer()
            
            Image(systemName: "gearshape.2.fill")
                .font(.system(size: 28, weight: .medium))
                .foregroundStyle(
                    LinearGradient(
                        colors: [ColorTheme.primaryBlue, ColorTheme.accentPurple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
        .padding(.top, 20)
        .padding(.bottom, 8)
    }
    
    private var notificationsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionLabel("Notifications")
            
            VStack(spacing: 0) {
                SettingsRowToggle(
                    icon: "bell.fill",
                    iconColor: ColorTheme.primaryBlue,
                    title: "Push Notifications",
                    isOn: Binding(
                        get: { appState.pushNotificationsEnabled },
                        set: { appState.pushNotificationsEnabled = $0; appState.saveNotificationSettings() }
                    )
                )
                
                Divider()
                    .padding(.leading, 52)
                    .background(ColorTheme.lightGray)
                
                SettingsRowToggle(
                    icon: "envelope.fill",
                    iconColor: ColorTheme.accentPurple,
                    title: "Email Updates",
                    isOn: Binding(
                        get: { appState.emailNotificationsEnabled },
                        set: { appState.emailNotificationsEnabled = $0; appState.saveNotificationSettings() }
                    )
                )
                
                Divider()
                    .padding(.leading, 52)
                    .background(ColorTheme.lightGray)
                
                SettingsRowToggle(
                    icon: "lightbulb.fill",
                    iconColor: ColorTheme.primaryYellow,
                    title: "Style Tips",
                    isOn: Binding(
                        get: { appState.styleTipsEnabled },
                        set: { appState.styleTipsEnabled = $0; appState.saveNotificationSettings() }
                    )
                )
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(ColorTheme.backgroundWhite)
                    .shadow(color: ColorTheme.primaryBlue.opacity(0.08), radius: 12, x: 0, y: 4)
            )
        }
    }
    
    private var appActionsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionLabel("App")
            
            VStack(spacing: 12) {
                SettingsActionTile(
                    icon: "star.fill",
                    title: "Rate App",
                    subtitle: "Share your experience",
                    gradient: [ColorTheme.primaryYellow, ColorTheme.primaryYellow.opacity(0.8)]
                ) {
                    requestAppReview()
                }
                
                SettingsActionTile(
                    icon: "square.and.arrow.up",
                    title: "Share App",
                    subtitle: "Invite friends",
                    gradient: [ColorTheme.primaryBlue, ColorTheme.primaryBlue.opacity(0.8)]
                ) {
                    shareApp()
                }
            }
        }
    }
    
    private var supportSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionLabel("Support & Legal")
            
            VStack(spacing: 0) {
                SettingsRowButton(
                    icon: "shield.fill",
                    title: "Privacy Policy",
                    action: {
                        if let url = URL(string: "https://doc-hosting.flycricket.io/lustre-gemline-privacy-policy/7b169932-f5fa-4233-a260-ab91c2465db4/privacy") {
                            UIApplication.shared.open(url)
                        }
                    }
                )
                
                Divider()
                    .padding(.leading, 52)
                    .background(ColorTheme.lightGray)
                
                SettingsRowButton(
                    icon: "envelope.circle.fill",
                    title: "Contact Us",
                    action: {
                        if let url = URL(string: "https://forms.gle/wLe9tktSwyzUNS38A") {
                            UIApplication.shared.open(url)
                        }
                    }
                )
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(ColorTheme.backgroundWhite)
                    .shadow(color: ColorTheme.primaryBlue.opacity(0.08), radius: 12, x: 0, y: 4)
            )
        }
    }
    
    private var sampleDataSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionLabel("Testing")
            
            SettingsActionTile(
                icon: "square.and.arrow.down.fill",
                title: "Load Sample Data",
                subtitle: "Add sample jewelry and try-on sessions",
                gradient: [ColorTheme.accentPurple, ColorTheme.accentPurple.opacity(0.8)]
            ) {
                appState.loadSampleData()
                showSampleDataLoaded = true
            }
        }
    }
    
    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.playfairDisplay(18, weight: .semibold))
            .foregroundColor(ColorTheme.primaryText)
            .padding(.leading, 4)
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func shareApp() {
        let activityVC = UIActivityViewController(
            activityItems: ["Check out JewelMate - the perfect jewelry companion app!"],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
}

struct SettingsRowToggle: View {
    let icon: String
    let iconColor: Color
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 14) {
            Button {
                isOn.toggle()
            } label: {
                HStack(spacing: 14) {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(iconColor)
                        .frame(width: 28, height: 28)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(iconColor.opacity(0.12))
                        )
                    
                    Text(title)
                        .font(.playfairDisplay(15, weight: .medium))
                        .foregroundColor(ColorTheme.primaryText)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(ColorTheme.primaryYellow)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
    }
}

struct SettingsRowButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(ColorTheme.primaryBlue)
                    .frame(width: 28, height: 28)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(ColorTheme.primaryBlue.opacity(0.12))
                    )
                
                Text(title)
                    .font(.playfairDisplay(15, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(ColorTheme.secondaryText)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
        }
    }
}

struct SettingsActionTile: View {
    let icon: String
    let title: String
    let subtitle: String
    let gradient: [Color]
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 18) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: gradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(ColorTheme.whiteText)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.playfairDisplay(17, weight: .semibold))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text(subtitle)
                        .font(.playfairDisplay(13, weight: .medium))
                        .foregroundColor(ColorTheme.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(ColorTheme.secondaryText)
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(ColorTheme.backgroundWhite)
                    .shadow(color: ColorTheme.primaryBlue.opacity(0.08), radius: 12, x: 0, y: 4)
            )
        }
    }
}

struct WebView: View {
    let url: String
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Privacy Policy")
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(ColorTheme.primaryText)
                    .padding()
                
                Text("This would open the privacy policy at: \(url)")
                    .font(.playfairDisplay(14))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                
                Button("Visit Google") {
                    if let url = URL(string: "https://google.com") {
                        UIApplication.shared.open(url)
                    }
                }
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(ColorTheme.whiteText)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(ColorTheme.primaryBlue)
                )
                .padding()
                
                Spacer()
            }
            .background(ColorTheme.backgroundGradient)
            .navigationBarItems(trailing: Button("Done") {})
        }
    }
}

struct ContactView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Image(systemName: "envelope.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(ColorTheme.primaryBlue)
                
                VStack(spacing: 12) {
                    Text("Contact Us")
                        .font(.playfairDisplay(24, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text("We'd love to hear from you!")
                        .font(.playfairDisplay(16))
                        .foregroundColor(ColorTheme.secondaryText)
                }
                
                Button("Open Email") {
                    if let url = URL(string: "https://google.com") {
                        UIApplication.shared.open(url)
                    }
                }
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(ColorTheme.whiteText)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(ColorTheme.primaryYellow)
                )
                
                Spacer()
            }
            .padding()
            .background(ColorTheme.backgroundGradient)
            .navigationBarItems(trailing: Button("Done") {})
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
}
