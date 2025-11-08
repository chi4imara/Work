import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    private let settingsItems = [
        SettingsItem(title: "Terms of Use", icon: "doc.text", action: .openURL),
        SettingsItem(title: "Privacy Policy", icon: "lock.shield", action: .openURL),
        SettingsItem(title: "Contact Us", icon: "envelope", action: .openURL),
        SettingsItem(title: "Rate App", icon: "star", action: .rateApp)
    ]
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                settingsGrid
                
                Spacer()
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(FontManager.largeTitle)
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 30)
    }
    
    private var settingsGrid: some View {
        VStack(spacing: 20) {
            ForEach(settingsItems, id: \.title) { item in
                SettingsCardView(item: item) {
                    handleSettingsAction(item.action, title: item.title)
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func handleSettingsAction(_ action: SettingsAction, title: String) {
        switch action {
        case .openURL:
            if let url = URL(string: title == "Terms of Use" ? "https://docs.google.com/document/d/1ipFCCbO1HP7iXUo4qmetCpBUrDyNEBh8mrpnXyyrIbg/edit?usp=sharing" : title == "Privacy Policy" ? "https://docs.google.com/document/d/1FvJNv1BNznBNtZ3JzEP03pf3BbxYoNDKY9fu22si2H0/edit?usp=sharing" : "https://forms.gle/DxNw7D57CQyFLgEb7") {
                UIApplication.shared.open(url)
            }
        case .rateApp:
            requestReview()
        }
    }
}

struct SettingsItem {
    let title: String
    let icon: String
    let action: SettingsAction
}

enum SettingsAction {
    case openURL
    case rateApp
}

struct SettingsCardView: View {
    let item: SettingsItem
    let onTap: () -> Void
    
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
                onTap()
            }
        }) {
            HStack(spacing: 16) {
                Image(systemName: item.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(ColorTheme.primaryBlue)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(ColorTheme.lightBlue.opacity(0.3))
                    )
                
                Text(item.title)
                    .font(FontManager.headline)
                    .foregroundColor(ColorTheme.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ColorTheme.lightBlue)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.cardGradient)
                    .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
                    .scaleEffect(isPressed ? 0.98 : 1.0)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
