import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(
                    LinearGradient(
                        colors: [AppColors.primaryBlue, AppColors.primaryYellow],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                )
                .frame(width: 40, height: 40)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
            
            Text("Loading...")
                .font(.playfair(.regular, size: 16))
                .foregroundColor(AppColors.secondaryText)
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
    let buttonAction: (() -> Void)?
    
    init(
        icon: String,
        title: String,
        subtitle: String,
        buttonTitle: String? = nil,
        buttonAction: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(AppColors.lightBlue)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.playfair(.semiBold, size: 20))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(.playfair(.regular, size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            if let buttonTitle = buttonTitle, let buttonAction = buttonAction {
                Button(action: buttonAction) {
                    HStack {
                        Image(systemName: "plus")
                        Text(buttonTitle)
                    }
                    .font(.playfair(.semiBold, size: 16))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(AppColors.primaryBlue)
                    .cornerRadius(20)
                }
            }
        }
        .padding(40)
    }
}

struct ErrorView: View {
    let message: String
    let retryAction: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(AppColors.alertRed)
            
            VStack(spacing: 8) {
                Text("Something went wrong")
                    .font(.playfair(.semiBold, size: 18))
                    .foregroundColor(AppColors.primaryText)
                
                Text(message)
                    .font(.playfair(.regular, size: 14))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            if let retryAction = retryAction {
                Button(action: retryAction) {
                    Text("Try Again")
                        .font(.playfair(.semiBold, size: 16))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(AppColors.primaryBlue)
                        .cornerRadius(20)
                }
            }
        }
        .padding(40)
    }
}

#Preview {
    VStack(spacing: 40) {
        LoadingView()
        
        EmptyStateView(
            icon: "leaf.fill",
            title: "No Plants Yet",
            subtitle: "Add your first plant to get started",
            buttonTitle: "Add Plant"
        ) {
            print("Add plant tapped")
        }
        
        ErrorView(message: "Failed to load data") {
            print("Retry tapped")
        }
    }
    .padding()
}
