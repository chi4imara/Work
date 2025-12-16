import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(Color.appPrimaryYellow.opacity(0.3), lineWidth: 3)
                    .frame(width: 50, height: 50)
                
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(Color.appPrimaryYellow, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
            }
            
            Text("Loading...")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(.appTextSecondary)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let description: String
    let buttonTitle: String?
    let buttonAction: (() -> Void)?
    
    init(icon: String, title: String, description: String, buttonTitle: String? = nil, buttonAction: (() -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.description = description
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.appTextTertiary)
            
            VStack(spacing: 12) {
                Text(title)
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(.appTextPrimary)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(.appTextSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            if let buttonTitle = buttonTitle, let buttonAction = buttonAction {
                CustomButton(title: buttonTitle, action: buttonAction)
            }
        }
        .padding(40)
    }
}

#Preview {
    ZStack {
        AnimatedBackground()
        
        VStack(spacing: 50) {
            LoadingView()
            
            EmptyStateView(
                icon: "wind",
                title: "No entries yet",
                description: "Start your scent diary today",
                buttonTitle: "Add First Entry",
                buttonAction: {}
            )
        }
    }
}
