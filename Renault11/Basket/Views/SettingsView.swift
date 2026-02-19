import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var viewModel: PurchaseViewModel
    @State private var showingPrivacyPolicy = false
    @State private var showingContactSheet = false
    @State private var showingSampleDataAlert = false
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    VStack(spacing: 8) {
                        Text("Settings")
                            .font(FontManager.playfairBold(size: 28))
                            .foregroundColor(Color.theme.primaryWhite)
                        
                        Text("Customize your shopping experience")
                            .font(FontManager.playfairRegular(size: 16))
                            .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        SettingsCard(
                            title: "Privacy Policy",
                            subtitle: "How we protect your data",
                            icon: "shield.checkerboard",
                            style: .large,
                            action: {
                                if let url = URL(string: "https://www.termsfeed.com/live/d8e7d7d4-aa0b-4df6-9376-4ad5119e5adf") {
                                    UIApplication.shared.open(url)
                                }                                }
                        )
                        
                        HStack(spacing: 15) {
                            SettingsCard(
                                title: "Contact Us",
                                subtitle: "Get in touch",
                                icon: "envelope.circle",
                                style: .medium,
                                action: {
                                    if let url = URL(string: "https://www.termsfeed.com/live/d8e7d7d4-aa0b-4df6-9376-4ad5119e5adf") {
                                        UIApplication.shared.open(url)
                                    }                                    }
                            )
                            
                            SettingsCard(
                                title: "Rate App",
                                subtitle: "Share feedback",
                                icon: "star.circle",
                                style: .medium,
                                action: {
                                    requestAppReview()
                                }
                            )
                        }
                        
                        AppInfoSection()
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 30)
            }
        }
        .alert("Sample Data Loaded", isPresented: $showingSampleDataAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("The app has been filled with test purchases. Check Today, My Purchases, History and Statistics.")
        }
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let style: CardStyle
    let action: () -> Void
    
    enum CardStyle {
        case large, medium, small
        
        var height: CGFloat {
            switch self {
            case .large: return 120
            case .medium: return 100
            case .small: return 80
            }
        }
        
        var iconSize: CGFloat {
            switch self {
            case .large: return 32
            case .medium: return 24
            case .small: return 20
            }
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                if style == .large {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Image(systemName: icon)
                                .font(.system(size: style.iconSize, weight: .medium))
                                .foregroundColor(Color.theme.primaryYellow)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(title)
                                    .font(FontManager.playfairBold(size: 20))
                                    .foregroundColor(Color.theme.primaryWhite)
                                
                                Text(subtitle)
                                    .font(FontManager.playfairRegular(size: 14))
                                    .foregroundColor(Color.theme.primaryWhite.opacity(0.7))
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color.theme.primaryYellow.opacity(0.7))
                    }
                } else {
                    VStack(spacing: 8) {
                        Image(systemName: icon)
                            .font(.system(size: style.iconSize, weight: .medium))
                            .foregroundColor(Color.theme.primaryYellow)
                        
                        VStack(spacing: 4) {
                            Text(title)
                                .font(FontManager.playfairSemiBold(size: 16))
                                .foregroundColor(Color.theme.primaryWhite)
                                .multilineTextAlignment(.center)
                            
                            Text(subtitle)
                                .font(FontManager.playfairRegular(size: 12))
                                .foregroundColor(Color.theme.primaryWhite.opacity(0.7))
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: style.height)
            .padding(20)
            .background(Color.theme.cardGradient)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.theme.primaryWhite.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

struct AppInfoSection: View {
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.theme.primaryYellow)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "bag.fill")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(Color.theme.darkBlue)
                    )
                    .shadow(color: Color.theme.primaryYellow.opacity(0.3), radius: 10, x: 0, y: 5)
                
                VStack(spacing: 4) {
                    Text("Shopping Energy")
                        .font(FontManager.playfairBold(size: 18))
                        .foregroundColor(Color.theme.primaryWhite)
                }
            }
            
            HStack(spacing: 20) {
                DecorativeIcon(icon: "heart.fill", color: Color.theme.softPink)
                DecorativeIcon(icon: "star.fill", color: Color.theme.primaryYellow)
                DecorativeIcon(icon: "sparkles", color: Color.theme.lightGreen)
            }
            
            Text("Made with love for conscious shopping")
                .font(FontManager.playfairRegular(size: 14))
                .foregroundColor(Color.theme.primaryWhite.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color.theme.cardGradient)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 8)
    }
}

struct DecorativeIcon: View {
    let icon: String
    let color: Color
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(color)
            .frame(width: 32, height: 32)
            .background(color.opacity(0.2))
            .cornerRadius(16)
    }
}

struct ContactSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    VStack(spacing: 16) {
                        Image(systemName: "envelope.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Color.theme.primaryYellow)
                        
                        VStack(spacing: 8) {
                            Text("Contact Us")
                                .font(FontManager.playfairBold(size: 24))
                                .foregroundColor(Color.theme.primaryWhite)
                            
                            Text("We'd love to hear from you!")
                                .font(FontManager.playfairRegular(size: 16))
                                .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
                        }
                    }
                    
                    VStack(spacing: 16) {
                        ContactOption(
                            icon: "envelope.fill",
                            title: "Email Support",
                            subtitle: "support@shoppingenergy.com",
                            action: {
                                openEmail()
                            }
                        )
                        
                        ContactOption(
                            icon: "globe",
                            title: "Visit Website",
                            subtitle: "Learn more about our mission",
                            action: {
                                openWebsite()
                            }
                        )
                        
                        ContactOption(
                            icon: "questionmark.circle.fill",
                            title: "FAQ",
                            subtitle: "Find answers to common questions",
                            action: {
                                openFAQ()
                            }
                        )
                    }
                    
                    Spacer()
                    
                    Button("Close") {
                        dismiss()
                    }
                    .font(FontManager.playfairSemiBold(size: 16))
                    .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.theme.primaryWhite.opacity(0.1))
                    .cornerRadius(22)
                    .padding(.horizontal, 40)
                }
                .padding(30)
            }
            .navigationBarHidden(true)
        }
    }
    
    private func openEmail() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openWebsite() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openFAQ() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
}

struct ContactOption: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(Color.theme.primaryYellow)
                    .frame(width: 50, height: 50)
                    .background(Color.theme.primaryYellow.opacity(0.2))
                    .cornerRadius(25)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(FontManager.playfairSemiBold(size: 16))
                        .foregroundColor(Color.theme.primaryWhite)
                    
                    Text(subtitle)
                        .font(FontManager.playfairRegular(size: 14))
                        .foregroundColor(Color.theme.primaryWhite.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.theme.primaryYellow.opacity(0.7))
            }
            .padding(16)
            .background(Color.theme.cardGradient)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct WebView: View {
    let url: String
    let title: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Opening \(title)...")
                        .font(FontManager.playfairRegular(size: 16))
                        .foregroundColor(Color.theme.primaryWhite)
                    
                    Button("Open in Browser") {
                        if let url = URL(string: url) {
                            UIApplication.shared.open(url)
                        }
                        dismiss()
                    }
                    .font(FontManager.playfairSemiBold(size: 16))
                    .foregroundColor(Color.theme.darkBlue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.theme.primaryYellow)
                    .cornerRadius(25)
                    .padding(.horizontal, 40)
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.primaryYellow)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if let url = URL(string: url) {
                    UIApplication.shared.open(url)
                }
                dismiss()
            }
        }
    }
}

#Preview {
    SettingsView(viewModel: PurchaseViewModel())
}
