import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateApp = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppGradient.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        appInfoSection
                        
                        legalSection
                        
                        supportSection
                        
                        aboutSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.primaryAccent)
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "sportscourt")
                        .font(.custom("Poppins-Medium", size: 40))
                        .foregroundColor(.white)
                )
            
            VStack(spacing: 4) {
                Text("Match Diary")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryText)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackground)
                .shadow(color: Color.shadowColor, radius: 8, x: 0, y: 4)
        )
    }
    
    private var legalSection: some View {
        VStack(spacing: 0) {
            Text("Legal")
                .font(.headline)
                .foregroundColor(.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 16)
            
            VStack(spacing: 1) {
                SettingsRow(
                    title: "Terms of Use",
                    icon: "doc.text",
                    action: {
                        openURL("https://google.com")
                    }
                )
                
                SettingsRow(
                    title: "Privacy Policy",
                    icon: "hand.raised",
                    action: {
                        openURL("https://google.com")
                    }
                )
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.cardBackground)
                    .shadow(color: Color.shadowColor, radius: 4, x: 0, y: 2)
            )
        }
    }
    
    private var supportSection: some View {
        VStack(spacing: 0) {
            Text("Support")
                .font(.headline)
                .foregroundColor(.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 16)
            
            VStack(spacing: 1) {
                SettingsRow(
                    title: "Contact Us",
                    icon: "envelope",
                    action: {
                        openURL("https://google.com")
                    }
                )
                
                SettingsRow(
                    title: "Rate App",
                    icon: "star",
                    action: {
                        requestReview()
                    },
                    showDivider: false
                )
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.cardBackground)
                    .shadow(color: Color.shadowColor, radius: 4, x: 0, y: 2)
            )
        }
    }
    
    private var aboutSection: some View {
        VStack(spacing: 16) {
            Text("About")
                .font(.headline)
                .foregroundColor(.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Match Diary helps amateur players track their games and build a personal archive of matches. Record scores, dates, and MVP players to keep your memorable moments alive.")
                    .font(.body)
                    .foregroundColor(.secondaryText)
                    .lineSpacing(2)
                
                Text("Perfect for recreational sports teams, weekend warriors, and anyone who wants to remember their best games.")
                    .font(.body)
                    .foregroundColor(.secondaryText)
                    .lineSpacing(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.cardBackground)
                    .shadow(color: Color.shadowColor, radius: 4, x: 0, y: 2)
            )
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    let action: () -> Void
    let showDivider: Bool
    
    init(title: String, icon: String, action: @escaping () -> Void, showDivider: Bool = true) {
        self.title = title
        self.icon = icon
        self.action = action
        self.showDivider = showDivider
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: action) {
                HStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.primaryAccent.opacity(0.1))
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: icon)
                            .font(.custom("Poppins-Medium", size: 16))
                            .foregroundColor(.primaryAccent)
                    }
                    
                    Text(title)
                        .font(.body)
                        .foregroundColor(.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: "chevron.right")
                        .font(.custom("Poppins-Medium", size: 14))
                        .foregroundColor(.secondaryText)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            .buttonStyle(PlainButtonStyle())
            
            if showDivider {
                Divider()
                    .padding(.leading, 64)
            }
        }
    }
}

struct SettingsButtonGrid: View {
    let buttons: [SettingsButtonData]
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                if buttons.count > 0 {
                    SettingsButton(data: buttons[0])
                        .frame(maxWidth: .infinity)
                }
                
                if buttons.count > 1 {
                    VStack(spacing: 8) {
                        SettingsButton(data: buttons[1])
                        if buttons.count > 2 {
                            SettingsButton(data: buttons[2])
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            
            if buttons.count > 3 {
                HStack(spacing: 12) {
                    if buttons.count > 3 {
                        SettingsButton(data: buttons[3])
                            .frame(maxWidth: .infinity)
                    }
                    
                    if buttons.count > 4 {
                        SettingsButton(data: buttons[4])
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
}

struct SettingsButton: View {
    let data: SettingsButtonData
    
    var body: some View {
        Button(action: data.action) {
            VStack(spacing: 8) {
                Image(systemName: data.icon)
                    .font(.title3)
                    .foregroundColor(.primaryAccent)
                
                Text(data.title)
                    .font(.caption)
                    .foregroundColor(.primaryText)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.cardBackground)
                    .shadow(color: Color.shadowColor, radius: 2, x: 0, y: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SettingsButtonData {
    let title: String
    let icon: String
    let action: () -> Void
}

#Preview {
    SettingsView()
}
