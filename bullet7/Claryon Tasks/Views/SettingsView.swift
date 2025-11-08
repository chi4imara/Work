import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        Text("Settings")
                            .font(Font.titleLarge)
                            .foregroundColor(Color.primaryText)
                        
                        Spacer()
                    }
                    .padding()
                    
                    VStack(spacing: 16) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(.accentYellow)
                        
                        Text("Claryon Tasks")
                            .font(.titleLarge)
                            .foregroundColor(.primaryWhite)
                        
                        Text("Keep your space clean, one zone at a time")
                            .font(.bodyMedium)
                            .foregroundColor(.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        HStack(spacing: 16) {
                            SettingsButton(
                                title: "Privacy Policy",
                                icon: "lock.shield",
                                action: { openURL("https://www.privacypolicies.com/live/ba727917-999e-4314-80d4-cf0ee27bf6af") }
                            )
                            
                            SettingsButton(
                                title: "Terms",
                                icon: "doc.text",
                                action: { openURL("https://www.privacypolicies.com/live/ca2c5a67-b504-4734-b503-b2aece38ad12") }
                            )
                        }
                        HStack(spacing: 16) {
                            SettingsButton(
                                title: "Rate App",
                                icon: "star",
                                action: { requestReview() }
                            )
                            
                            SettingsButton(
                                title: "Contact",
                                icon: "envelope",
                                action: { openURL("https://www.privacypolicies.com/live/ba727917-999e-4314-80d4-cf0ee27bf6af") }
                            )
                        }
                        
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 40)
                }
                .padding(.bottom, 100)
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.accentYellow)
                
                Text(title)
                    .font(.bodySmall)
                    .foregroundColor(.primaryWhite)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(Color.cardBackground)
            .cornerRadius(12)
        }
    }
}

#Preview {
    SettingsView()
}
