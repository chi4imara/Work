import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let description: String
    let buttonTitle: String?
    let buttonAction: (() -> Void)?
    
    init(
        icon: String,
        title: String,
        description: String,
        buttonTitle: String? = nil,
        buttonAction: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.description = description
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: icon)
                .font(.system(size: 60, weight: .light))
                .foregroundColor(Color.theme.secondaryText)
            
            VStack(spacing: 12) {
                Text(title)
                    .font(.ubuntu(20, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.ubuntu(16, weight: .light))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 40)
            
            if let buttonTitle = buttonTitle, let buttonAction = buttonAction {
                Button(action: buttonAction) {
                    Text(buttonTitle)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(Color.theme.primaryText)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.theme.primaryPurple)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.theme.primaryWhite.opacity(0.3), lineWidth: 1)
                                )
                        )
                }
                .padding(.top, 8)
            }
        }
    }
}

#Preview {
    ZStack {
        AnimatedBackground()
        
        EmptyStateView(
            icon: "heart",
            title: "No entries yet",
            description: "Every day consists of three moments. Start with one — simply notice what you liked.",
            buttonTitle: "Start Noticing",
            buttonAction: {}
        )
    }
}
