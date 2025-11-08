import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) private var requestReview
    @State private var animateCards = false
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            ForEach(0..<8, id: \.self) { index in
                Circle()
                    .fill(Color.primaryYellow.opacity(0.1))
                    .frame(width: CGFloat.random(in: 20...60))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...150)
                    )
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 3...6))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.5),
                        value: animateCards
                    )
            }
            
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Settings")
                            .font(.titleLarge)
                            .foregroundColor(.primaryWhite)
                        
                        Text("Manage your app preferences")
                            .font(.bodyMedium)
                            .foregroundColor(.primaryWhite.opacity(0.8))
                    }
                    .padding(.vertical, 8)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 20) {
                                SettingsCard(
                                    title: "Terms of Use",
                                    subtitle: "Legal information",
                                    icon: "doc.text.fill",
                                    gradient: [.blue, .purple],
                                    action: { openURL("https://docs.google.com/document/d/1oYlK5GgwDPhRi5e-XH4xY4lp-O9KYvdjuK2twfWwECE/edit?usp=sharing") }
                                )
                                
                                SettingsCard(
                                    title: "Privacy Policy",
                                    subtitle: "Data protection",
                                    icon: "hand.raised.fill",
                                    gradient: [.green, .mint],
                                    action: { openURL("https://docs.google.com/document/d/1xrPQmxFJ7RvFtLFnSrprRkjvTXdILXJtju-TyqjmJrA/edit?usp=sharing") }
                                )
                                
                                SettingsCard(
                                    title: "Contact Us",
                                    subtitle: "Get in touch",
                                    icon: "envelope.fill",
                                    gradient: [.orange, .red],
                                    action: { openURL("https://forms.gle/eHhhdeHC95r9yefXA") }
                                )
                                
                                SettingsCard(
                                    title: "Rate App",
                                    subtitle: "Share feedback",
                                    icon: "star.fill",
                                    gradient: [.yellow, .orange],
                                    action: { requestReview() }
                                )
                            }
                            .padding(.horizontal, 20)
                            
                            VStack(spacing: 16) {
                                HStack {
                                    Text("About")
                                        .font(.titleMedium)
                                        .foregroundColor(.primaryWhite)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                
                                VStack(spacing: 12) {
                                    AboutRow(
                                        title: "Description",
                                        value: "Track your home purchases",
                                        icon: "house.fill",
                                        iconColor: .green
                                    )
                                    
                                    AboutRow(
                                        title: "Features",
                                        value: "Purchase tracking & statistics",
                                        icon: "chart.bar.fill",
                                        iconColor: .purple
                                    )
                                    
                                    AboutRow(
                                        title: "Data Storage",
                                        value: "Local device only",
                                        icon: "externaldrive.fill",
                                        iconColor: .orange
                                    )
                                }
                                .padding(.horizontal, 20)
                            }
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.top, 20)
                    }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animateCards = true
            }
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
    let gradient: [Color]
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var animateIcon = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
                action()
            }
        }) {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: gradient),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                        .scaleEffect(animateIcon ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateIcon)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.bodyLarge)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    Text(subtitle)
                        .font(.bodySmall)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.cardBackground)
                    .shadow(
                        color: gradient.first?.opacity(0.3) ?? .clear,
                        radius: isPressed ? 8 : 4,
                        x: 0,
                        y: isPressed ? 4 : 2
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).delay(Double.random(in: 0...1))) {
                animateIcon = true
            }
        }
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    let iconColor: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
                action()
            }
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.bodyLarge)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.cardBackground)
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AboutRow: View {
    let title: String
    let value: String
    let icon: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.bodyMedium)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.bodyLarge)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.cardBackground)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
}

#Preview {
    SettingsView()
}
