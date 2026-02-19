import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingPrivacyPolicy = false
    @State private var showingContactEmail = false
    @State private var emailText = ""
    @State private var showingSampleDataLoaded = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Settings")
                        .font(Theme.Fonts.playfairBold(size: 24))
                        .foregroundColor(Theme.Colors.text)
                    
                    Spacer()
                }
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.vertical, Theme.Spacing.lg)
                
                ScrollView {
                    VStack(spacing: Theme.Spacing.lg) {
                        AppInfoSection()
                        
                        SettingsOptionsView(
                            showingPrivacyPolicy: $showingPrivacyPolicy,
                            showingContactEmail: $showingContactEmail
                        )
                        
                        AppVersionSection()
                    }
                    .padding(.horizontal, Theme.Spacing.md)
                    .padding(.top, Theme.Spacing.lg)
                    .padding(.bottom, 120)
                }
            }
        }
        .alert("Sample Data Loaded", isPresented: $showingSampleDataLoaded) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Sample habits and daily entries have been added. Switch to Today or My Habits to see them.")
        }
    }
}

struct AppInfoSection: View {
    var body: some View {
        VStack(spacing: Theme.Spacing.md) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Theme.Colors.primary, Theme.Colors.accent],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: "heart.text.square.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 40))
            }
            
            VStack(spacing: Theme.Spacing.xs) {
                Text("Gratitude & Joy Diary")
                    .font(Theme.Fonts.playfairBold(size: 20))
                    .foregroundColor(Theme.Colors.text)
                
                Text("Your daily companion for mindfulness and positivity")
                    .font(Theme.Fonts.playfairRegular(size: 14))
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.lg)
                .fill(Theme.Colors.background.opacity(0.8))
        )
    }
}

struct SampleDataSection: View {
    @Binding var showingSampleDataLoaded: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text("Testing")
                .font(Theme.Fonts.playfairSemiBold(size: 16))
                .foregroundColor(Theme.Colors.textSecondary)
            
            SettingsRow(
                icon: "square.and.arrow.down.fill",
                title: "Load Sample Data",
                subtitle: "Add sample habits and diary entries for testing",
                action: {
                    SampleData.loadSampleData()
                    showingSampleDataLoaded = true
                }
            )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.lg)
                .fill(Theme.Colors.background.opacity(0.8))
        )
    }
}

struct SettingsOptionsView: View {
    @Binding var showingPrivacyPolicy: Bool
    @Binding var showingContactEmail: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            SettingsRow(
                icon: "hand.raised.fill",
                title: "Privacy Policy",
                subtitle: "How we protect your data",
                action: {
                    if let url = URL(string: "https://www.termsfeed.com/live/54ccaac7-ef8d-4202-91cd-eee949e2cd86") {
                        UIApplication.shared.open(url)
                    }
                }
            )
            
            Divider()
                .padding(.leading, 60)
            
            SettingsRow(
                icon: "envelope.fill",
                title: "Contact Us",
                subtitle: "Get in touch with our team",
                action: {  if let url = URL(string: "https://www.termsfeed.com/live/54ccaac7-ef8d-4202-91cd-eee949e2cd86") {
                    UIApplication.shared.open(url)
                }
                }
            )
            
            Divider()
                .padding(.leading, 60)
            
            SettingsRow(
                icon: "star.fill",
                title: "Rate the App",
                subtitle: "Share your experience",
                action: { requestAppReview() }
            )
        }
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.lg)
                .fill(Theme.Colors.background.opacity(0.8))
        )
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.md) {
                ZStack {
                    Circle()
                        .fill(Theme.Colors.primary.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .foregroundColor(Theme.Colors.primary)
                        .font(.system(size: 18))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(Theme.Fonts.playfairSemiBold(size: 16))
                        .foregroundColor(Theme.Colors.text)
                    
                    Text(subtitle)
                        .font(Theme.Fonts.playfairRegular(size: 12))
                        .foregroundColor(Theme.Colors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(Theme.Colors.textSecondary)
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.vertical, Theme.Spacing.md)
            .background(
                Rectangle()
                    .fill(isPressed ? Theme.Colors.primary.opacity(0.05) : Color.clear)
            )
        }
        .onLongPressGesture(minimumDuration: 0) { pressing in
            withAnimation(Theme.Animation.quick) {
                isPressed = pressing
            }
        } perform: {
            action()
        }
    }
}

struct AppVersionSection: View {
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    var body: some View {
        VStack(spacing: Theme.Spacing.sm) {
            Text("Made with ❤️ for your wellbeing")
                .font(Theme.Fonts.playfairItalic(size: 12))
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.lg)
                .fill(Theme.Colors.background.opacity(0.5))
        )
    }
}

struct WebView: View {
    let url: String
    let title: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: Theme.Spacing.lg) {
                    Image(systemName: "globe")
                        .font(.system(size: 60))
                        .foregroundColor(Theme.Colors.primary)
                    
                    Text("Opening \(title)")
                        .font(Theme.Fonts.playfairSemiBold(size: 18))
                        .foregroundColor(Theme.Colors.text)
                    
                    Text("This would normally open a web view to: \(url)")
                        .font(Theme.Fonts.playfairRegular(size: 14))
                        .foregroundColor(Theme.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Theme.Spacing.lg)
                    
                    Button("Open in Safari") {
                        if let url = URL(string: url) {
                            UIApplication.shared.open(url)
                        }
                        dismiss()
                    }
                    .font(Theme.Fonts.playfairSemiBold(size: 16))
                    .foregroundColor(.white)
                    .padding(.horizontal, Theme.Spacing.lg)
                    .padding(.vertical, Theme.Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.md)
                            .fill(Theme.Colors.primary)
                    )
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ContactEmailView: View {
    @Binding var emailText: String
    @Environment(\.dismiss) private var dismiss
    @State private var showingEmailSent = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: Theme.Spacing.lg) {
                    VStack(spacing: Theme.Spacing.md) {
                        Image(systemName: "envelope.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Theme.Colors.primary)
                        
                        Text("Contact Us")
                            .font(Theme.Fonts.playfairBold(size: 24))
                            .foregroundColor(Theme.Colors.text)
                        
                        Text("We'd love to hear from you! Send us your feedback, questions, or suggestions.")
                            .font(Theme.Fonts.playfairRegular(size: 16))
                            .foregroundColor(Theme.Colors.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                        Text("Your Message")
                            .font(Theme.Fonts.playfairSemiBold(size: 16))
                            .foregroundColor(Theme.Colors.text)
                        
                        TextField("Type your message here...", text: $emailText, axis: .vertical)
                            .font(Theme.Fonts.playfairRegular(size: 14))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .lineLimit(8, reservesSpace: true)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.lg)
                            .fill(Theme.Colors.background.opacity(0.8))
                    )
                    
                    Button(action: sendEmail) {
                        HStack {
                            Image(systemName: "paperplane.fill")
                            Text("Send Message")
                        }
                        .font(Theme.Fonts.playfairSemiBold(size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Theme.Spacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.md)
                                .fill(
                                    emailText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?
                                    Theme.Colors.textSecondary : Theme.Colors.primary
                                )
                        )
                    }
                    .disabled(emailText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    
                    Spacer()
                }
                .padding(.horizontal, Theme.Spacing.md)
            }
            .navigationTitle("Contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .alert("Message Sent", isPresented: $showingEmailSent) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Thank you for your message! We'll get back to you soon.")
        }
    }
    
    private func sendEmail() {
        showingEmailSent = true
        
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
}

struct CreativeSettingsLayout: View {
    var body: some View {
        EmptyView()
    }
}

#Preview {
    SettingsView()
}
