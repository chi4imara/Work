import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    init(
        icon: String,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .stroke(AppColors.primary.opacity(0.1), lineWidth: 2)
                    .frame(width: 140, height: 140)
                
                Circle()
                    .stroke(AppColors.primary.opacity(0.2), lineWidth: 1)
                    .frame(width: 120, height: 120)
                
                Image(systemName: icon)
                    .font(.system(size: 48, weight: .light))
                    .foregroundColor(AppColors.textSecondary.opacity(0.6))
            }
            
            VStack(spacing: 12) {
                Text(title)
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(message)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
            
            if let actionTitle = actionTitle, let action = action {
                PixelButton(actionTitle, style: .primary, action: action)
                    .frame(maxWidth: 200)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    ZStack {
        AppColors.backgroundGradient
            .ignoresSafeArea()
        
        EmptyStateView(
            icon: "doc.text",
            title: "No Victories Yet",
            message: "Start adding your daily victories to see them here. Every small win counts!",
            actionTitle: "Add Victory",
            action: { }
        )
    }
}
