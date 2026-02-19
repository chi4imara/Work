import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(Color.theme.primaryYellow, lineWidth: 4)
                .frame(width: 40, height: 40)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(
                    Animation.linear(duration: 1)
                        .repeatForever(autoreverses: false),
                    value: isAnimating
                )
            
            Text("Loading...")
                .font(FontManager.playfairRegular(size: 14))
                .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    let buttonTitle: String?
    let action: (() -> Void)?
    
    init(icon: String, title: String, subtitle: String, buttonTitle: String? = nil, action: (() -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.buttonTitle = buttonTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: icon)
                .font(.system(size: 60, weight: .light))
                .foregroundColor(Color.theme.primaryYellow.opacity(0.6))
            
            VStack(spacing: 8) {
                Text(title)
                    .font(FontManager.playfairBold(size: 20))
                    .foregroundColor(Color.theme.primaryWhite)
                
                Text(subtitle)
                    .font(FontManager.playfairRegular(size: 14))
                    .foregroundColor(Color.theme.primaryWhite.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            if let buttonTitle = buttonTitle, let action = action {
                Button(action: action) {
                    Text(buttonTitle)
                        .font(FontManager.playfairSemiBold(size: 16))
                        .foregroundColor(Color.theme.darkBlue)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.theme.primaryYellow)
                        .cornerRadius(25)
                        .shadow(color: Color.theme.primaryYellow.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 40)
            }
        }
        .padding(40)
    }
}

#Preview {
    ZStack {
        Color.theme.backgroundGradient
            .ignoresSafeArea()
        
        EmptyStateView(
            icon: "bag",
            title: "No Purchases Yet",
            subtitle: "Add your first purchase and start planning your shopping journey",
            buttonTitle: "Add Purchase"
        ) {
        }
    }
}
