import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) private var requestReview
    
    var body: some View {
        ZStack {
            WebPatternBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerView
                        
                        appInfoSection
                        
                        legalSection
                        
                        supportSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Settings")
                    .font(FontManager.title)
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Manage your app preferences")
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.secondaryText)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 10)
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [ColorTheme.primaryBlue, ColorTheme.darkBlue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                        .shadow(color: ColorTheme.primaryBlue.opacity(0.3), radius: 15, x: 0, y: 8)
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 4) {
                    Text("Hobby Organizer")
                        .font(FontManager.headline)
                        .foregroundColor(ColorTheme.primaryText)
                        .fontWeight(.bold)
                }
            }
            
            Text("Turn your hobbies into habits with smart tracking and beautiful analytics.")
                .font(FontManager.body)
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
        }
        .padding(24)
        .background(ColorTheme.cardGradient)
        .cornerRadius(20)
        .shadow(color: ColorTheme.lightBlue.opacity(0.15), radius: 10, x: 0, y: 5)
    }
    
    private var legalSection: some View {
        SettingsSection(title: "Legal") {
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "doc.text.fill",
                    title: "Terms of Use",
                    iconColor: ColorTheme.primaryBlue
                ) {
                    openURL("https://docs.google.com/document/d/13WaBv5B81HW__7XOD7fWxRACgzKE3AX4Wo0c1PhMQTg/edit?usp=sharing")
                }
                
                Divider()
                    .padding(.leading, 52)
                
                SettingsRow(
                    icon: "hand.raised.fill",
                    title: "Privacy Policy",
                    iconColor: ColorTheme.accent
                ) {
                    openURL("https://docs.google.com/document/d/1QRBTyKBplVRpPTOllQQVbL6B6bvZm1uS5HIUCH32RSk/edit?usp=sharing")
                }
            }
        }
    }
    
    private var supportSection: some View {
        SettingsSection(title: "Support") {
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "envelope.fill",
                    title: "Contact Us",
                    iconColor: ColorTheme.warning
                ) {
                    openURL("https://forms.gle/YjEyyRqsRyC23Qk97")
                }
                
                Divider()
                    .padding(.leading, 52)
                
                SettingsRow(
                    icon: "star.fill",
                    title: "Rate the App",
                    iconColor: ColorTheme.primaryBlue
                ) {
                    requestReview()
                }
            }
        }
    }
    
    private var aboutSection: some View {
        SettingsSection(title: "About") {
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "info.circle.fill",
                    title: "License Agreement",
                    iconColor: ColorTheme.darkBlue
                ) {
                    openURL("https://google.com")
                }
                
                Divider()
                    .padding(.leading, 52)
                
                SettingsRow(
                    icon: "questionmark.circle.fill",
                    title: "User Agreement",
                    iconColor: ColorTheme.accent
                ) {
                    openURL("https://google.com")
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
                .font(FontManager.subheadline)
                .foregroundColor(ColorTheme.primaryText)
                .fontWeight(.semibold)
                .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                content
            }
            .background(ColorTheme.cardGradient)
            .cornerRadius(16)
            .shadow(color: ColorTheme.lightBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconColor.opacity(0.1))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ColorTheme.lightBlue)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(SettingsButtonStyle())
    }
}

struct SettingsButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                configuration.isPressed ? 
                ColorTheme.lightBlue.opacity(0.1) : 
                Color.clear
            )
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct CreativeSettingsGrid: View {
    let items: [(String, String, Color, () -> Void)]
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ], spacing: 12) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                Button(action: item.3) {
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(item.2.opacity(0.1))
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: item.0)
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(item.2)
                        }
                        
                        Text(item.1)
                            .font(FontManager.body)
                            .foregroundColor(ColorTheme.primaryText)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(20)
                    .background(ColorTheme.cardGradient)
                    .cornerRadius(16)
                    .shadow(color: ColorTheme.lightBlue.opacity(0.1), radius: 6, x: 0, y: 3)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct AlternativeSettingsView: View {
    @Environment(\.requestReview) private var requestReview
    
    var body: some View {
        ZStack {
            WebPatternBackground()
            
            VStack(spacing: 0) {
                ZStack {
                    RoundedRectangle(cornerRadius: 0)
                        .fill(ColorTheme.cardGradient)
                        .frame(height: 120)
                        .overlay(
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Settings")
                                        .font(FontManager.title)
                                        .foregroundColor(ColorTheme.primaryText)
                                    
                                    Text("Customize your experience")
                                        .font(FontManager.body)
                                        .foregroundColor(ColorTheme.secondaryText)
                                }
                                
                                Spacer()
                                
                                ZStack {
                                    Circle()
                                        .fill(ColorTheme.primaryBlue.opacity(0.1))
                                        .frame(width: 60, height: 60)
                                    
                                    Image(systemName: "gearshape.2.fill")
                                        .font(.system(size: 28, weight: .medium))
                                        .foregroundColor(ColorTheme.primaryBlue)
                                }
                            }
                            .padding(.horizontal, 20)
                        )
                }
                
                ScrollView {
                    VStack(spacing: 24) {
                        CreativeSettingsGrid(items: [
                            ("doc.text.fill", "Terms of Use", ColorTheme.primaryBlue, { openURL("https://docs.google.com/document/d/13WaBv5B81HW__7XOD7fWxRACgzKE3AX4Wo0c1PhMQTg/edit?usp=sharing") }),
                            ("hand.raised.fill", "Privacy Policy", ColorTheme.accent, { openURL("https://docs.google.com/document/d/1QRBTyKBplVRpPTOllQQVbL6B6bvZm1uS5HIUCH32RSk/edit?usp=sharing") }),
                            ("envelope.fill", "Contact Us", ColorTheme.warning, { openURL("https://forms.gle/YjEyyRqsRyC23Qk97") }),
                            ("star.fill", "Rate App", ColorTheme.success, { requestReview() })
                        ])
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
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
