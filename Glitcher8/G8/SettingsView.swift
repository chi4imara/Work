import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
            ZStack {
                RadialGradientBackground()
                
                ScrollView {
                    VStack(spacing: 0) {
                        Text("Settings")
                            .font(.ubuntu(32, weight: .bold))
                            .foregroundColor(.pureWhite)
                            .padding(.vertical, 30)
                        
                        VStack(spacing: 20) {
                            SettingsRow(
                                title: "Data Protection Policy",
                                subtitle: "How we protect your data",
                                icon: "lock.shield",
                                iconColor: .brightOrange,
                                gradientColors: [Color.brightOrange.opacity(0.3), Color.brightOrange.opacity(0.1)]
                            ) {
                                openURL("https://www.termsfeed.com/live/3d94c6f8-c8b0-461a-8087-5816796a87ef")
                            }
                            
                            SettingsRow(
                                title: "Contact Us",
                                subtitle: "Get in touch with us",
                                icon: "envelope.circle.fill",
                                iconColor: .softGreen,
                                gradientColors: [Color.softGreen.opacity(0.3), Color.softGreen.opacity(0.1)]
                            ) {
                                openURL("https://www.termsfeed.com/live/3d94c6f8-c8b0-461a-8087-5816796a87ef")
                            }
                            
                            SettingsRow(
                                title: "Rate App",
                                subtitle: "Share your feedback",
                                icon: "star.circle.fill",
                                iconColor: Color(red: 1.0, green: 0.8, blue: 0.0),
                                gradientColors: [Color(red: 1.0, green: 0.8, blue: 0.0).opacity(0.3), Color(red: 1.0, green: 0.8, blue: 0.0).opacity(0.1)]
                            ) {
                                requestReview()
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
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

struct SettingsRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let iconColor: Color
    let gradientColors: [Color]
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.system(size: 26, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.ubuntu(18, weight: .semibold))
                        .foregroundColor(.pureWhite)
                    
                    Text(subtitle)
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(.pureWhite.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.pureWhite.opacity(0.5))
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.pureWhite.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [iconColor.opacity(0.3), Color.clear],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
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
}
