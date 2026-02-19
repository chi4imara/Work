import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            AppColorScheme.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Image(systemName: "gear")
                            .font(.system(size: 60))
                            .foregroundColor(Color.primaryYellow)
                        
                        Text("Settings")
                            .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                            .foregroundColor(Color.textPrimary)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        SettingsRowView(
                            icon: "shield.checkered",
                            title: "Privacy Policy",
                            action: {
                                if let url = URL(string: "https://www.privacypolicies.com/live/5cabc35e-36e9-4fbb-bed7-9cfa8cd9a10f") {
                                    UIApplication.shared.open(url)
                                }
                            }
                        )
                        
                        SettingsRowView(
                            icon: "envelope",
                            title: "Contact Us",
                            action: {
                                if let url = URL(string: "https://www.privacypolicies.com/live/5cabc35e-36e9-4fbb-bed7-9cfa8cd9a10f") {
                                    UIApplication.shared.open(url)
                                }
                            }
                        )
                        
                        SettingsRowView(
                            icon: "star",
                            title: "Rate App",
                            action: {
                                requestReview()
                            }
                        )
                    }
                }
                .padding()
            }
        }
    }
}

struct SettingsRowView: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.primaryYellow.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(Color.primaryYellow)
                }
                
                Text(title)
                    .font(FontManager.playfairDisplay(size: 18, weight: .medium))
                    .foregroundColor(Color.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .foregroundColor(Color.textSecondary)
            }
            .padding()
            .background(AppColorScheme.cardGradient)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
        }
    }
}

#Preview {
    SettingsView()
}
