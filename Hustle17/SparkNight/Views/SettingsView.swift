import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
            ZStack {
                StaticBackground()
        
                    ScrollView {
                        VStack(spacing: 0) {
                            Text("Settings")
                                .font(.theme.title1)
                                .foregroundColor(.black)
                            
                            VStack(spacing: 20) {
                                ZStack {
                                    Circle()
                                        .fill(ColorTheme.blueGradient)
                                        .frame(width: 80, height: 80)
                                    
                                    Image(systemName: "party.popper")
                                        .font(.system(size: 32, weight: .medium))
                                        .foregroundColor(ColorTheme.textLight)
                                }
                                
                                VStack(spacing: 8) {
                                    Text("SparkNight")
                                        .font(.theme.title2)
                                        .foregroundColor(ColorTheme.textPrimary)
                                }
                            }
                            .padding(.vertical, 30)
                            
                            VStack(spacing: 24) {
                                SettingsSection(title: "Legal") {
                                    VStack(spacing: 0) {
                                        SettingsRow(
                                            title: "Terms of Use",
                                            icon: "doc.text",
                                            action: { openURL("https://docs.google.com/document/d/1ZFgWQoEG_3GQL1A70d_I9bQH8M8kzJnJxLMpx2qJZxo/edit?usp=sharing") }
                                        )
                                        
                                        Divider()
                                            .padding(.leading, 50)
                                        
                                        SettingsRow(
                                            title: "Privacy Policy",
                                            icon: "hand.raised",
                                            action: { openURL("https://docs.google.com/document/d/17As6wKVr6yPslTYHo-ST_m5oQBujI1cK4RFat-uhY0k/edit?usp=sharing") }
                                        )
                                    }
                                }
                                
                                SettingsSection(title: "Support") {
                                    VStack(spacing: 0) {
                                        SettingsRow(
                                            title: "Contact Us",
                                            icon: "envelope",
                                            action: { openURL("https://forms.gle/6LuEXxZcndcLzubc8") }
                                        )
                                        
                                        Divider()
                                            .padding(.leading, 50)
                                        
                                        SettingsRow(
                                            title: "Rate App",
                                            icon: "star",
                                            action: { requestReview() }
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            Spacer(minLength: 100)
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
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.theme.headline)
                .foregroundColor(ColorTheme.textPrimary)
                .padding(.horizontal, 16)
            
            content
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(ColorTheme.backgroundWhite)
                        .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
                )
        }
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
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(ColorTheme.primaryBlue)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.theme.body)
                    .foregroundColor(ColorTheme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ColorTheme.textSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
    }
}

struct CreativeSettingsSection: View {
    @State private var animateElements = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("More Options")
                .font(.theme.headline)
                .foregroundColor(ColorTheme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
            
            ZStack {
                Circle()
                    .fill(ColorTheme.backgroundWhite)
                    .frame(width: 200, height: 200)
                    .shadow(color: ColorTheme.primaryBlue.opacity(0.15), radius: 15, x: 0, y: 8)
                
                VStack(spacing: 8) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(ColorTheme.primaryBlue)
                    
                    Text("Settings")
                        .font(.theme.caption1)
                        .foregroundColor(ColorTheme.textSecondary)
                }
                .scaleEffect(animateElements ? 1.1 : 1.0)
                
                ForEach(0..<4, id: \.self) { index in
                    let angle = Double(index) * 90 - 45
                    let radius: CGFloat = 70
                    
                    CircularSettingsButton(
                        icon: circularButtonData[index].icon,
                        title: circularButtonData[index].title,
                        color: circularButtonData[index].color,
                        action: circularButtonData[index].action
                    )
                    .offset(
                        x: cos(angle * .pi / 180) * radius,
                        y: sin(angle * .pi / 180) * radius
                    )
                    .scaleEffect(animateElements ? 1.0 : 0.8)
                    .opacity(animateElements ? 1.0 : 0.7)
                    .animation(.easeOut(duration: 0.6).delay(Double(index) * 0.1), value: animateElements)
                }
            }
            .frame(height: 220)
            .onAppear {
                withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
                    animateElements = true
                }
            }
        }
    }
    
    private var circularButtonData: [(icon: String, title: String, color: Color, action: () -> Void)] {
        [
            ("doc.text.fill", "Terms", ColorTheme.accentGreen, { openURL("https://google.com") }),
            ("hand.raised.fill", "Privacy", ColorTheme.accentOrange, { openURL("https://google.com") }),
            ("envelope.fill", "Contact", ColorTheme.accentPink, { openURL("https://google.com") }),
            ("star.fill", "Rate", ColorTheme.accentPurple, { 
                if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            })
        ]
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct CircularSettingsButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.theme.caption2)
                    .foregroundColor(ColorTheme.textSecondary)
            }
        }
        .scaleEffect(isPressed ? 0.9 : 1.0)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
                action()
            }
        }
    }
}

#Preview {
    SettingsView()
}
