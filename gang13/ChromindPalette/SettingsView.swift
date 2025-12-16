import SwiftUI
import StoreKit

struct SettingsView: View {
    @StateObject private var colorTheme = ColorTheme.shared
    @State private var showingRateApp = false
    @State private var selectedButton: String?
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    headerView
                    
                    ScrollView {
                        VStack(spacing: 30) {
                            modernSettingsLayout
                            
                            Spacer(minLength: 50)
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        Text("Settings")
            .font(.playfairDisplay(24, weight: .bold))
            .foregroundColor(colorTheme.primaryWhite)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
    }
    
    private var modernSettingsLayout: some View {
        VStack(spacing: 20) {
            SettingsSection(title: "Legal", icon: "doc.text") {
                VStack(spacing: 12) {
                    ModernSettingsButton(
                        title: "Terms & Conditions",
                        subtitle: "Read our terms of service",
                        icon: "doc.text",
                        iconColor: colorTheme.primaryPurple,
                        action: openTerms
                    )
                    
                    ModernSettingsButton(
                        title: "Privacy Policy",
                        subtitle: "How we protect your data",
                        icon: "hand.raised",
                        iconColor: Color.blue,
                        action: openPrivacy
                    )
                }
            }
            
            SettingsSection(title: "Support", icon: "questionmark.circle") {
                VStack(spacing: 12) {
                    ModernSettingsButton(
                        title: "Contact Us",
                        subtitle: "Get in touch with us",
                        icon: "envelope",
                        iconColor: colorTheme.warningOrange,
                        action: openContact
                    )
                }
            }
            
            SettingsSection(title: "App", icon: "star") {
                VStack(spacing: 12) {
                    ModernSettingsButton(
                        title: "Rate App",
                        subtitle: "Share your experience",
                        icon: "star",
                        iconColor: colorTheme.warningOrange,
                        action: rateApp
                    )
                }
            }
        }
    }
    
    private func openTerms() {
        if let url = URL(string: "https://www.privacypolicies.com/live/42364189-5334-4726-8e64-60565a756a3d") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openPrivacy() {
        if let url = URL(string: "https://www.privacypolicies.com/live/be16dc08-c27a-4801-9df3-f0390de19519") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openContact() {
        if let url = URL(string: "https://www.privacypolicies.com/live/be16dc08-c27a-4801-9df3-f0390de19519") {
            UIApplication.shared.open(url)
        }
    }
    
    private func rateApp() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func openSupport() {
        if let url = URL(string: "https://www.privacypolicies.com/live/be16dc08-c27a-4801-9df3-f0390de19519") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openAbout() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    @StateObject private var colorTheme = ColorTheme.shared
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(colorTheme.primaryPurple)
                
                Text(title)
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(colorTheme.primaryWhite)
            }
            
            content
        }
        .padding(20)
        .background(colorTheme.primaryWhite.opacity(0.08))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(colorTheme.primaryWhite.opacity(0.15), lineWidth: 1)
        )
    }
}

struct ModernSettingsButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let iconColor: Color
    let action: () -> Void
    @StateObject private var colorTheme = ColorTheme.shared
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
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.playfairDisplay(16, weight: .semibold))
                        .foregroundColor(colorTheme.primaryWhite)
                    
                    Text(subtitle)
                        .font(.playfairDisplay(13, weight: .regular))
                        .foregroundColor(colorTheme.primaryWhite.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(colorTheme.primaryWhite.opacity(0.4))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(colorTheme.primaryWhite.opacity(0.05))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(colorTheme.primaryWhite.opacity(0.1), lineWidth: 1)
            )
        }
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
}

struct MenuView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var colorTheme = ColorTheme.shared
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 30) {
                    Text("Menu")
                        .font(.playfairDisplay(24, weight: .bold))
                        .foregroundColor(colorTheme.primaryWhite)
                        .padding(.top)
                    
                    VStack(spacing: 20) {
                        MenuButton(
                            title: "Color History",
                            icon: "clock",
                            destination: {
                                withAnimation {
                                    selectedTab = 1
                                    dismiss()
                                }
                            }
                        )
                        
                        MenuButton(
                            title: "My Notes",
                            icon: "note.text",
                            destination: {
                                withAnimation {
                                    selectedTab = 2
                                    dismiss()
                                }
                            }
                        )
                        
                        MenuButton(
                            title: "Statistics",
                            icon: "chart.bar",
                            destination: {
                                withAnimation {
                                    selectedTab = 3
                                    dismiss()
                                }
                            }
                        )
                    }
                    
                    Spacer()
                    
                    Button("Close") {
                        dismiss()
                    }
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(colorTheme.primaryWhite.opacity(0.7))
                    .padding(.bottom, 30)
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}

struct MenuButton: View {
    let title: String
    let icon: String
    let destination: () -> Void
    @StateObject private var colorTheme = ColorTheme.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
         Button(action: destination) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(colorTheme.primaryPurple)
                    .frame(width: 30)
                
                Text(title)
                    .font(.playfairDisplay(18, weight: .medium))
                    .foregroundColor(colorTheme.primaryWhite)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(colorTheme.primaryWhite.opacity(0.5))
            }
            .padding()
            .background(colorTheme.primaryWhite.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(colorTheme.primaryWhite.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(TapGesture().onEnded {
            dismiss()
        })
    }
}

#Preview {
    SettingsView()
}
