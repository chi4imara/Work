import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    SettingsHeaderView()
                    
                    VStack(spacing: 20) {
                        HStack(spacing: 16) {
                            SettingsCardView(
                                title: "Rate App",
                                subtitle: "Love the app?",
                                icon: "star.fill",
                                color: AppColors.accent,
                                isLarge: false
                            ) {
                                requestReview()
                            }
                            
                            SettingsCardView(
                                title: "Contact Us",
                                subtitle: "Get in touch",
                                icon: "envelope.fill",
                                color: AppColors.success,
                                isLarge: false
                            ) {
                                openURL("https://forms.gle/2496j3ArFRteWZAv6")
                            }
                        }
                        
                        SettingsCardView(
                            title: "Privacy Policy",
                            subtitle: "How we protect your data and respect your privacy",
                            icon: "shield.fill",
                            color: Color.blue,
                            isLarge: true
                        ) {
                            openURL("https://docs.google.com/document/d/1oS-bJ9cywoZAK32IVBXCNWHJ132wG6oqhpp-dCX-jnU/edit?usp=sharing")
                        }
                        
                        HStack(spacing: 16) {
                            SettingsCardView(
                                title: "Terms of Use",
                                subtitle: "Legal agreement",
                                icon: "doc.text.fill",
                                color: Color.purple,
                                isLarge: false
                            ) {
                                openURL("https://docs.google.com/document/d/1AnL2nbmco3qvqqhFz38kl-4ryUwk4OYdqOkyVflra7k/edit?usp=sharing")
                            }
                            
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 120)
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsHeaderView: View {
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColors.accent.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "calendar.badge.plus")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(AppColors.accent)
            }
            
            VStack(spacing: 4) {
                Text("Holiday Calendar")
                    .font(FontManager.title)
                    .foregroundColor(AppColors.primaryText)
            }
        }
        .padding(.vertical, 20)
    }
}

struct SettingsCardView: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let isLarge: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: isLarge ? 28 : 24, weight: .medium))
                        .foregroundColor(color)
                    
                    if !isLarge {
                        Spacer()
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(isLarge ? FontManager.headline : FontManager.subheadline)
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.leading)
                    
                    Text(subtitle)
                        .font(FontManager.small)
                        .foregroundColor(AppColors.secondaryText.opacity(0.8))
                        .multilineTextAlignment(.leading)
                        .lineLimit(isLarge ? 2 : 1)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: isLarge ? 140 : 120)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: color.opacity(0.2), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FloatingInfoButton: View {
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        HStack {
            Spacer()
            
            Button(action: action) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [AppColors.accent, AppColors.accent.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 70, height: 70)
                        .scaleEffect(isPressed ? 0.95 : 1.0)
                        .shadow(color: AppColors.accent.opacity(0.4), radius: 12, x: 0, y: 6)
                    
                    VStack(spacing: 2) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(AppColors.background)
                        
                        Text("Info")
                            .font(FontManager.small)
                            .foregroundColor(AppColors.background)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .padding(.trailing, 20)
        }
        .padding(.top, 20)
    }
}

struct AlternativeSettingsLayout: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 40) {
                    SettingsHeaderView()
                    
                    VStack(spacing: 20) {
                        HexagonalCard(
                            title: "Privacy Policy",
                            icon: "shield.fill",
                            color: Color.blue
                        ) {
                            openURL("https://docs.google.com/document/d/1oS-bJ9cywoZAK32IVBXCNWHJ132wG6oqhpp-dCX-jnU/edit?usp=sharing")
                        }
                        
                        HStack(spacing: 20) {
                            HexagonalCard(
                                title: "Rate App",
                                icon: "star.fill",
                                color: AppColors.accent
                            ) {
                                requestReview()
                            }
                            
                            HexagonalCard(
                                title: "Contact",
                                icon: "envelope.fill",
                                color: AppColors.success
                            ) {
                                openURL("https://forms.gle/2496j3ArFRteWZAv6")
                            }
                        }
                        
                        HexagonalCard(
                            title: "Terms of Use",
                            icon: "doc.text.fill",
                            color: Color.purple
                        ) {
                            openURL("https://docs.google.com/document/d/1AnL2nbmco3qvqqhFz38kl-4ryUwk4OYdqOkyVflra7k/edit?usp=sharing")
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct HexagonalCard: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(color)
                
                Text(title)
                    .font(FontManager.subheadline)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 140, height: 120)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(AppColors.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(color.opacity(0.4), lineWidth: 2)
                    )
                    .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 5)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
}
