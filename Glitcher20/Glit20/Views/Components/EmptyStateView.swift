import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String?
    
    init(icon: String, title: String, subtitle: String? = nil) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(Color.textSecondary)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(Color.textPrimary)
                    .multilineTextAlignment(.center)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(FontManager.playfairDisplay(size: 14))
                        .foregroundColor(Color.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ZStack {
        AppColorScheme.backgroundGradient
            .ignoresSafeArea()
        
        EmptyStateView(
            icon: "tshirt",
            title: "No items found",
            subtitle: "Add your first wardrobe item to get started"
        )
    }
}
