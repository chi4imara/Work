import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var bubbles: [MovingBubble] = []
    
    var body: some View {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ForEach(bubbles, id: \.id) { bubble in
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: bubble.size, height: bubble.size)
                        .position(bubble.position)
                        .animation(.linear(duration: bubble.duration).repeatForever(autoreverses: false), value: bubble.position)
                }
                
                ScrollView {
                    VStack(spacing: 24) {
                        HStack {
                            Text("Settings")
                                .font(.ubuntu(28, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                        }
                        .padding(.vertical)
                        .padding(.horizontal, 20)

                        HStack {
                            Text("Customize your experience")
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(AppColors.secondaryText)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 20) {
                            SettingsSectionView(
                                title: "Legal",
                                items: [
                                    SettingsItemView(
                                        title: "Terms of Use",
                                        subtitle: "Read our terms and conditions",
                                        icon: "doc.text",
                                        color: Color.pink
                                    ) {
                                        viewModel.openURL("https://www.termsfeed.com/live/467c31ec-7aee-4f36-9db7-920c28b1c1fd")
                                    },
                                    SettingsItemView(
                                        title: "Privacy Policy",
                                        subtitle: "How we protect your data",
                                        icon: "lock.shield",
                                        color: Color.green
                                    ) {
                                        viewModel.openURL("https://www.termsfeed.com/live/87d1e70b-511b-447c-a82c-1809ffd6f47e")
                                    }
                                ]
                            )
                            
                            SettingsSectionView(
                                title: "Support",
                                items: [
                                    SettingsItemView(
                                        title: "Contact Us",
                                        subtitle: "Get help and support",
                                        icon: "envelope",
                                        color: Color.blue
                                    ) {
                                        viewModel.openURL("https://www.termsfeed.com/live/87d1e70b-511b-447c-a82c-1809ffd6f47e")
                                    }
                                ]
                            )
                            
                            SettingsSectionView(
                                title: "App",
                                items: [
                                    SettingsItemView(
                                        title: "Rate App",
                                        subtitle: "Share your feedback with us",
                                        icon: "star.fill",
                                        color: AppColors.yellow
                                    ) {
                                        viewModel.rateApp()
                                    }
                                ]
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
        .onAppear {
            generateBubbles()
        }
    }
    
    private func generateBubbles() {
        bubbles = (0..<10).map { _ in
            MovingBubble(
                id: UUID(),
                size: CGFloat.random(in: 25...55),
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: UIScreen.main.bounds.height + 100
                ),
                duration: Double.random(in: 12...25)
            )
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            for i in bubbles.indices {
                bubbles[i].position = CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: -100
                )
            }
        }
    }
}

struct SettingsSectionView: View {
    let title: String
    let items: [SettingsItemView]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 4)
            
            VStack(spacing: 8) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    item
                }
            }
        }
    }
}

struct SettingsItemView: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
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
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.leading)
                    
                    Text(subtitle)
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(AppColors.white.opacity(0.2), lineWidth: 1)
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
}

