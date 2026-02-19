import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var appViewModel: AppViewModel
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    settingsGrid
                }
                .padding()
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "gearshape.fill")
                .font(.system(size: 50))
                .foregroundColor(ColorTheme.primaryBlue)
            
            Text("App Settings")
                .font(.playfair(24, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Text("Manage your preferences and app information")
                .font(.playfair(16))
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 20)
    }
    
    private var settingsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ], spacing: 20) {
            SettingsCard(
                title: "Privacy Policy",
                subtitle: "Data protection policy",
                icon: "shield.fill",
                color: ColorTheme.primaryBlue,
                position: .topLeft
            ) {
                openURL("https://doc-hosting.flycricket.io/slow-hours-freeform-privacy-policy/8a13648d-0f9e-4d50-b3f1-33e66f836687/privacy")
            }
            
            SettingsCard(
                title: "Contact Us",
                subtitle: "Get in touch",
                icon: "envelope.fill",
                color: ColorTheme.accentOrange,
                position: .topRight
            ) {
                openURL("https://forms.gle/VFNX2AfC3GEJaFre8")
            }
            
            SettingsCard(
                title: "Rate App",
                subtitle: "Leave a review",
                icon: "star.fill",
                color: ColorTheme.primaryYellow,
                position: .bottomLeft
            ) {
                requestAppReview()
            }
        }
    }
    
    private var sampleDataSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Testing")
                .font(.playfair(18, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            Button(action: {
                appViewModel.loadSampleData()
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "square.and.arrow.down.fill")
                        .font(.system(size: 20))
                    Text("Load Sample Data")
                        .font(.playfair(16, weight: .medium))
                    Spacer()
                }
                .foregroundColor(ColorTheme.primaryText)
                .padding()
                .background(ColorTheme.buttonGradient)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: ColorTheme.primaryYellow.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            .padding(.top, 8)
        }
        .padding(.top, 24)
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

struct SettingsCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let position: CardPosition
    let action: () -> Void
    
    enum CardPosition {
        case topLeft, topRight, bottomLeft, bottomRight
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                HStack {
                    if position == .topRight || position == .bottomRight {
                        Spacer()
                    }
                    
                    Image(systemName: icon)
                        .font(.system(size: cardIconSize))
                        .foregroundColor(color)
                    
                    if position == .topLeft || position == .bottomLeft {
                        Spacer()
                    }
                }
                
                VStack(spacing: 6) {
                    Text(title)
                        .font(.playfair(cardTitleSize, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                        .multilineTextAlignment(textAlignment)
                    
                    Text(subtitle)
                        .font(.playfair(cardSubtitleSize))
                        .foregroundColor(ColorTheme.secondaryText)
                        .multilineTextAlignment(textAlignment)
                }
                
                if position == .topLeft || position == .topRight {
                    Spacer()
                }
            }
            .padding(cardPadding)
            .frame(height: cardHeight)
            .background(
                RoundedRectangle(cornerRadius: cardCornerRadius)
                    .fill(
                        LinearGradient(
                            colors: [
                                ColorTheme.backgroundWhite,
                                color.opacity(0.1)
                            ],
                            startPoint: gradientStartPoint,
                            endPoint: gradientEndPoint
                        )
                    )
                    .shadow(color: color.opacity(0.2), radius: 8, x: shadowOffset.x, y: shadowOffset.y)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cardCornerRadius)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var cardIconSize: CGFloat {
        switch position {
        case .topLeft: return 32
        case .topRight: return 28
        case .bottomLeft: return 36
        case .bottomRight: return 30
        }
    }
    
    private var cardTitleSize: CGFloat {
        switch position {
        case .topLeft: return 18
        case .topRight: return 16
        case .bottomLeft: return 20
        case .bottomRight: return 17
        }
    }
    
    private var cardSubtitleSize: CGFloat {
        switch position {
        case .topLeft: return 14
        case .topRight: return 13
        case .bottomLeft: return 15
        case .bottomRight: return 13
        }
    }
    
    private var cardPadding: CGFloat {
        switch position {
        case .topLeft: return 20
        case .topRight: return 16
        case .bottomLeft: return 24
        case .bottomRight: return 18
        }
    }
    
    private var cardHeight: CGFloat {
        switch position {
        case .topLeft: return 140
        case .topRight: return 130
        case .bottomLeft: return 150
        case .bottomRight: return 135
        }
    }
    
    private var cardCornerRadius: CGFloat {
        switch position {
        case .topLeft: return 20
        case .topRight: return 16
        case .bottomLeft: return 24
        case .bottomRight: return 18
        }
    }
    
    private var textAlignment: TextAlignment {
        switch position {
        case .topLeft, .bottomLeft: return .leading
        case .topRight, .bottomRight: return .trailing
        }
    }
    
    private var gradientStartPoint: UnitPoint {
        switch position {
        case .topLeft: return .topLeading
        case .topRight: return .topTrailing
        case .bottomLeft: return .bottomLeading
        case .bottomRight: return .bottomTrailing
        }
    }
    
    private var gradientEndPoint: UnitPoint {
        switch position {
        case .topLeft: return .bottomTrailing
        case .topRight: return .bottomLeading
        case .bottomLeft: return .topTrailing
        case .bottomRight: return .topLeading
        }
    }
    
    private var shadowOffset: CGPoint {
        switch position {
        case .topLeft: return CGPoint(x: -2, y: -2)
        case .topRight: return CGPoint(x: 2, y: -2)
        case .bottomLeft: return CGPoint(x: -2, y: 2)
        case .bottomRight: return CGPoint(x: 2, y: 2)
        }
    }
}

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Privacy Policy")
                            .font(.playfair(28, weight: .bold))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        Text("Last updated: \(getCurrentDate())")
                            .font(.playfair(14))
                            .foregroundColor(ColorTheme.secondaryText)
                        
                        privacyContent
                        
                        Button("View Full Policy Online") {
                            openURL(URL(string: "https://google.com")!)
                        }
                        .font(.playfair(16, weight: .medium))
                        .foregroundColor(ColorTheme.primaryBlue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(ColorTheme.primaryBlue, lineWidth: 1)
                        )
                    }
                    .padding()
                }
            }
            .navigationTitle("Privacy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.primaryBlue)
                }
            }
        }
    }
    
    private var privacyContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            privacySection(
                title: "Information We Collect",
                content: "LeisureTime collects minimal personal information necessary to provide our services, including your activity preferences, scheduled events, and progress data."
            )
            
            privacySection(
                title: "How We Use Your Information",
                content: "Your data is used solely to personalize your leisure recommendations, track your progress, and improve your experience within the app."
            )
            
            privacySection(
                title: "Data Storage",
                content: "All your personal data is stored locally on your device. We do not transmit or store your personal information on external servers."
            )
            
            privacySection(
                title: "Third-Party Services",
                content: "LeisureTime does not share your personal information with third-party services or advertisers."
            )
            
            privacySection(
                title: "Contact Us",
                content: "If you have any questions about this Privacy Policy, please contact us through the app's contact feature."
            )
        }
    }
    
    private func privacySection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.playfair(18, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            Text(content)
                .font(.playfair(16))
                .foregroundColor(ColorTheme.secondaryText)
                .lineSpacing(4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorTheme.cardGradient)
        )
    }
    
    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }
}

struct ContactEmailView: View {
    @Binding var emailText: String
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @State private var subject = ""
    @State private var message = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        headerSection
                        contactForm
                        quickActions
                    }
                    .padding()
                }
            }
            .navigationTitle("Contact Us")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Send") {
                        sendEmail()
                    }
                    .foregroundColor(ColorTheme.primaryBlue)
                    .fontWeight(.semibold)
                    .disabled(subject.isEmpty || message.isEmpty)
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Get in Touch")
                .font(.playfair(24, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Text("We'd love to hear from you! Send us your feedback, questions, or suggestions.")
                .font(.playfair(16))
                .foregroundColor(ColorTheme.secondaryText)
                .lineSpacing(4)
        }
    }
    
    private var contactForm: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Subject")
                    .font(.playfair(16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                
                TextField("What's this about?", text: $subject)
                    .font(.playfair(16))
                    .padding()
                    .background(ColorTheme.backgroundWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(ColorTheme.lightBlue, lineWidth: 1)
                    )
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Message")
                    .font(.playfair(16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                
                TextEditor(text: $message)
                    .font(.playfair(16))
                    .frame(minHeight: 120)
                    .padding()
                    .background(ColorTheme.backgroundWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(ColorTheme.lightBlue, lineWidth: 1)
                    )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
        )
    }
    
    private var quickActions: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.playfair(18, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 12) {
                quickActionButton("Report a Bug", icon: "ladybug.fill", color: ColorTheme.accentOrange) {
                    subject = "Bug Report"
                    message = "I found a bug in the app:\n\n"
                }
                
                quickActionButton("Feature Request", icon: "lightbulb.fill", color: ColorTheme.primaryYellow) {
                    subject = "Feature Request"
                    message = "I would like to suggest a new feature:\n\n"
                }
                
                quickActionButton("General Feedback", icon: "heart.fill", color: ColorTheme.accentPink) {
                    subject = "Feedback"
                    message = "Here's my feedback about the app:\n\n"
                }
            }
        }
    }
    
    private func quickActionButton(_ title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.playfair(16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(ColorTheme.secondaryText)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorTheme.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
    
    private func sendEmail() {
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://google.com"
        
        if let url = URL(string: urlString) {
            openURL(url)
        }
        
        dismiss()
    }
}

#Preview {
    SettingsView(appViewModel: AppViewModel())
}
