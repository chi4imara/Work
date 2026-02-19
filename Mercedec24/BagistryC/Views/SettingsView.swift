import SwiftUI
import StoreKit

struct SettingsView: View {
    @EnvironmentObject private var bagViewModel: BagViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    @State private var showSampleDataAlert = false
    
    var body: some View {
        ZStack {
            backgroundView
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 28) {
                    headerSection
                    
                    supportSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 100)
            }
        }
        .alert("Sample Data Loaded", isPresented: $showSampleDataAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Test bags, user profile, try-on sessions and achievements have been loaded. Check Home, Collection, Progress and Profile.")
        }
    }
    
    private var backgroundView: some View {
        ZStack {
            LinearGradient(
                colors: [Color.theme.gradientStart, Color.theme.gradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            GridPattern()
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 6) {
            Text("Settings")
                .font(.ubuntu(32, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            Text("Customize your experience")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(Color.theme.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 8)
    }
    
    private var testingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("Testing")
            
            Button(action: loadSampleData) {
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.theme.accentYellow.opacity(0.25))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "square.and.arrow.down.fill")
                            .font(.system(size: 18))
                            .foregroundColor(Color.theme.accentYellow)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Load Sample Data")
                            .font(.ubuntu(16, weight: .bold))
                            .foregroundColor(Color.theme.primaryText)
                        
                        Text("Fill app with test bags, sessions and achievements")
                            .font(.ubuntu(13))
                            .foregroundColor(Color.theme.secondaryText)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color.theme.secondaryText)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            .background(Color.theme.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.theme.cardBorder, lineWidth: 1)
            )
        }
    }
    
    private func loadSampleData() {
        SampleDataService.loadSampleData()
        bagViewModel.refreshBags()
        userViewModel.refreshFromStorage()
        userViewModel.setCollectionCount(bagViewModel.favoriteBags.count)
        showSampleDataAlert = true
    }
    
    private var supportSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("Support")
            
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "shield.fill",
                    iconColor: Color.theme.primaryButton,
                    title: "Privacy Policy",
                    subtitle: "Data protection and privacy"
                ) {
                    openURL("https://doc-hosting.flycricket.io/bagistry-carry-code-privacy-policy/c8f5658a-edff-43d3-983e-7edc04a9db7e/privacy")
                }
                
                settingsDivider
                
                SettingsRow(
                    icon: "star.fill",
                    iconColor: Color.theme.accentYellow,
                    title: "Rate App",
                    subtitle: "Share your feedback with us"
                ) {
                    requestReview()
                }
                
                settingsDivider
                
                SettingsRow(
                    icon: "envelope.fill",
                    iconColor: Color.blue,
                    title: "Contact Us",
                    subtitle: "Get in touch"
                ) {
                    openURL("https://forms.gle/1u2UUu3jqhiap7jv8")
                }
            }
            .background(Color.theme.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.theme.cardBorder, lineWidth: 1)
            )
        }
    }
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionLabel("About")
            
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "questionmark.circle.fill",
                    iconColor: Color.theme.lightBlue,
                    title: "Help",
                    subtitle: "FAQ and support"
                ) {
                    openURL("https://google.com")
                }
                
                settingsDivider
                
                SettingsRow(
                    icon: "doc.text.fill",
                    iconColor: Color.theme.darkBlue,
                    title: "Terms of Service",
                    subtitle: "Legal information"
                ) {
                    openURL("https://google.com")
                }
            }
            .background(Color.theme.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.theme.cardBorder, lineWidth: 1)
            )
        }
    }
    
    private var appVersionSection: some View {
        VStack(spacing: 6) {
            Text("BagLover")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            Text("Version 1.0.0")
                .font(.ubuntu(14))
                .foregroundColor(Color.theme.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
    
    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.ubuntu(14, weight: .bold))
            .foregroundColor(Color.theme.accentYellow)
            .padding(.leading, 4)
    }
    
    private var settingsDivider: some View {
        Rectangle()
            .fill(Color.theme.cardBorder)
            .frame(height: 1)
            .padding(.leading, 56)
    }
    
    private func requestReview() {
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

struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(iconColor.opacity(0.25))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Text(subtitle)
                        .font(.ubuntu(13))
                        .foregroundColor(Color.theme.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.theme.secondaryText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }
}

struct ContactView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var message = ""
    @State private var email = ""
    @State private var subject = "App Feedback"
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.theme.gradientStart, Color.theme.gradientEnd],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Image(systemName: "envelope.fill")
                            .font(.system(size: 40))
                            .foregroundColor(Color.theme.accentYellow)
                        
                        Text("Get in Touch")
                            .font(.ubuntu(24, weight: .bold))
                            .foregroundColor(Color.theme.primaryText)
                        
                        Text("We'd love to hear from you!")
                            .font(.ubuntu(16))
                            .foregroundColor(Color.theme.secondaryText)
                    }
                    
                    VStack(spacing: 16) {
                        CustomTextField(title: "Your Email", text: $email, placeholder: "your@email.com")
                        
                        CustomTextField(title: "Subject", text: $subject, placeholder: "What's this about?")
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Message")
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(Color.theme.primaryText)
                            
                            TextField("Tell us what's on your mind...", text: $message, axis: .vertical)
                                .font(.ubuntu(14))
                                .foregroundColor(Color.theme.primaryText)
                                .padding(12)
                                .background(Color.theme.cardBackground)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.theme.cardBorder, lineWidth: 1)
                                )
                                .lineLimit(5...10)
                        }
                    }
                    .padding(16)
                    .background(Color.theme.cardBackground)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.theme.cardBorder, lineWidth: 1)
                    )
                    
                    Button(action: sendMessage) {
                        Text("Send Message")
                            .font(.ubuntu(18, weight: .bold))
                            .foregroundColor(Color.theme.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.theme.primaryButton)
                            .cornerRadius(25)
                    }
                    .disabled(email.isEmpty || message.isEmpty)
                    .opacity(email.isEmpty || message.isEmpty ? 0.6 : 1.0)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
            }
            .navigationTitle("Contact Us")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.primaryText)
                }
            }
            .toolbarBackground(Color.theme.cardBackground, for: .navigationBar)
        }
    }
    
    private func sendMessage() {
        print("Sending message: \(message)")
        dismiss()
    }
}

struct WebView: View {
    let url: String
    let title: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.theme.gradientStart, Color.theme.gradientEnd],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Image(systemName: "globe")
                        .font(.system(size: 60))
                        .foregroundColor(Color.theme.accentYellow)
                    
                    Text("Opening \(title)")
                        .font(.ubuntu(20, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Text("This would open the web page in a real app")
                        .font(.ubuntu(14))
                        .foregroundColor(Color.theme.secondaryText)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        if let url = URL(string: url) {
                            UIApplication.shared.open(url)
                        }
                        dismiss()
                    }) {
                        Text("Open in Browser")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.theme.primaryButton)
                            .cornerRadius(25)
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.accentYellow)
                }
            }
            .toolbarBackground(Color.theme.cardBackground, for: .navigationBar)
        }
    }
}

#Preview {
    NavigationView {
        SettingsView()
            .environmentObject(BagViewModel())
            .environmentObject(UserViewModel())
    }
}
