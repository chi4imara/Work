import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    VStack(spacing: 8) {
                        Text("Settings")
                            .font(.playfairDisplay(size: 28, weight: .bold))
                            .foregroundColor(.primaryPurple)
                        
                        Text("App preferences and information")
                            .font(.playfairDisplay(size: 16))
                            .foregroundColor(.accentBlue)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                    
                    VStack(spacing: 20) {
                        SettingsSection(title: "Legal & Privacy") {
                            VStack(spacing: 12) {
                                SettingsRow(
                                    title: "Terms of Use",
                                    icon: "doc.text",
                                    action: { openURL("https://www.termsfeed.com/live/30d3c2ae-c15c-4e98-b733-d9f8801eaa8b") }
                                )
                                
                                Divider()
                                    .frame(maxWidth: .infinity)
                                
                                SettingsRow(
                                    title: "Privacy Policy",
                                    icon: "hand.raised",
                                    action: { openURL("https://www.termsfeed.com/live/df8ee14c-5d8e-4fea-98b0-2390e135e06c") }
                                )
                            }
                        }
                        
                        SettingsSection(title: "Support & Feedback") {
                            VStack(spacing: 12) {
                                SettingsRow(
                                    title: "Contact Us",
                                    icon: "envelope",
                                    action: { openURL("https://www.termsfeed.com/live/df8ee14c-5d8e-4fea-98b0-2390e135e06c") }
                                )
                                
                                Divider()
                                    .frame(maxWidth: .infinity)
                                
                                SettingsRow(
                                    title: "Rate the App",
                                    icon: "star",
                                    action: { requestReview() }
                                )
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 8)
                }
            }
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
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(title)
                    .font(.playfairDisplay(size: 18, weight: .bold))
                    .foregroundColor(.primaryPurple)
                
                Spacer()
            }
            
            content
        }
        .padding(20)
        .background(Color.white.opacity(0.9))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.accentBlue)
                    .frame(width: 24)
                
                Text(title)
                    .font(.playfairDisplay(size: 16))
                    .foregroundColor(.darkGray)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.lightGray)
            }
            .padding(.vertical, 8)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
