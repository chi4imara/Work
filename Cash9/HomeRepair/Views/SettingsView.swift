import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) private var requestReview
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            appSection
                            
                            legalSection
                            
                            supportSection
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                    }
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var appSection: some View {
        VStack(spacing: 0) {
            HStack {
                Text("App")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.lightBlue.opacity(0.3))
            
            SettingsRow(
                icon: "star.fill",
                iconColor: .accentOrange,
                title: "Rate the App",
                subtitle: "Help us improve with your feedback"
            ) {
                requestReview()
            }
        }
        .background(Color.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.cardShadow, radius: 3, x: 0, y: 1)
    }
    
    private var legalSection: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Legal")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.lightBlue.opacity(0.3))
            
            SettingsRow(
                icon: "doc.text.fill",
                iconColor: .primaryBlue,
                title: "Terms of Use",
                subtitle: "Read our terms and conditions"
            ) {
                openURL("https://docs.google.com/document/d/1KlW4E56JxPOBnhsZ2TwjxbzgxEPoQ-sZCIlLs36bLDU/edit?usp=sharing")
            }
            
            Divider()
                .padding(.leading, 60)
            
            SettingsRow(
                icon: "lock.shield.fill",
                iconColor: .accentGreen,
                title: "Privacy Policy",
                subtitle: "Learn how we protect your data"
            ) {
                openURL("https://docs.google.com/document/d/1sOlzqRIokpV3pRhW_5E-emwNiQUOdCV7omhYNRJzMtk/edit?usp=sharing")
            }
        }
        .background(Color.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.cardShadow, radius: 3, x: 0, y: 1)
    }
    
    private var supportSection: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Support")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.lightBlue.opacity(0.3))
            
            SettingsRow(
                icon: "envelope.fill",
                iconColor: .accentRed,
                title: "Contact Us",
                subtitle: "Get in touch with our support team"
            ) {
                openURL("https://forms.gle/Usvwc8UYFjPyLTct6")
            }
        }
        .background(Color.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.cardShadow, radius: 3, x: 0, y: 1)
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
            HStack(spacing: 15) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.textPrimary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
}

