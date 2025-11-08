import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateApp = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Settings")
                    .font(AppFonts.title)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.primaryBlue)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 20)
            
            ScrollView {
                VStack(spacing: 24) {
                    SettingsSection(title: "App") {
                        VStack(spacing: 0) {
                            SettingsRow(
                                title: "Rate the App",
                                icon: "star.fill",
                                action: { requestAppReview() }
                            )
                            
                            Divider()
                                .padding(.leading, 50)
                            
                            SettingsRow(
                                title: "Contact Us",
                                icon: "envelope.fill",
                                action: { openURL("https://www.termsfeed.com/live/a80174a5-596c-4932-962d-9fb1d325e33b") }
                            )
                        }
                    }
                    
                    SettingsSection(title: "Legal") {
                        VStack(spacing: 0) {
                            SettingsRow(
                                title: "Terms of Use",
                                icon: "doc.text.fill",
                                action: { openURL("https://www.termsfeed.com/live/bb29d53f-4294-4339-9ed6-b9a0e6e38a31") }
                            )
                            
                            Divider()
                                .padding(.leading, 50)
                            
                            SettingsRow(
                                title: "Privacy Policy",
                                icon: "lock.shield.fill",
                                action: { openURL("https://www.termsfeed.com/live/a80174a5-596c-4932-962d-9fb1d325e33b") }
                            )
                        }
                    }
                    
                    SettingsSection(title: "About") {
                        VStack(spacing: 16) {
                            HStack {
                                Image(systemName: "app.badge")
                                    .font(.system(size: 40))
                                    .foregroundColor(AppColors.primaryBlue)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("WordellDiary")
                                        .font(AppFonts.headline)
                                        .fontWeight(.medium)
                                        .foregroundColor(AppColors.primaryBlue)
                                }
                                
                                Spacer()
                            }
                            
                            Text("Describe your day, one word picture at a time. A simple diary app that focuses on the power of words to capture life's moments.")
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.darkGray)
                                .multilineTextAlignment(.leading)
                                .lineSpacing(2)
                        }
                        .padding(16)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100) 
            }
        }
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
                .font(AppFonts.caption)
                .foregroundColor(AppColors.darkGray.opacity(0.7))
                .textCase(.uppercase)
                .padding(.horizontal, 16)
            
            content
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.cardGradient)
                        .shadow(color: AppColors.darkGray.opacity(0.1), radius: 8, x: 0, y: 4)
                }
        }
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppColors.accentYellow.opacity(0.2))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.primaryBlue)
                }
                
                Text(title)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.darkGray)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.darkGray.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.clear)
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    SettingsView()
        .background(AppColors.mainBackgroundGradient)
}
