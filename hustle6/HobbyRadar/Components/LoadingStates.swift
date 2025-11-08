import SwiftUI

struct LoadingButton: View {
    let title: String
    let isLoading: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: AppColors.onPrimary))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "dice.fill")
                        .font(.system(size: 20, weight: .semibold))
                }
                
                Text(isLoading ? "Generating..." : title)
                    .font(AppFonts.buttonTitle)
            }
            .foregroundColor(AppColors.onPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(isLoading ? AnyShapeStyle(AppColors.buttonDisabled) : AnyShapeStyle(AppColors.primaryGradient))
            )
            .shadow(
                color: isLoading ? Color.clear : AppColors.primary.opacity(0.3),
                radius: 8,
                x: 0,
                y: 4
            )
            .scaleEffect(isLoading ? 0.98 : 1.0)
        }
        .disabled(isLoading)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
}

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
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(AppColors.primary.opacity(0.1))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: icon)
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(AppColors.primary)
                }
                
                VStack(spacing: 12) {
                    Text(title)
                        .font(AppFonts.title2)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(description)
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            
            if let buttonTitle = buttonTitle, let buttonAction = buttonAction {
                Button(action: buttonAction) {
                    Text(buttonTitle)
                        .font(AppFonts.buttonTitle)
                        .foregroundColor(AppColors.onPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(AppColors.primaryGradient)
                        .cornerRadius(28)
                        .shadow(color: AppColors.primary.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

struct ErrorStateView: View {
    let title: String
    let description: String
    let retryAction: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(AppColors.warning)
                
                VStack(spacing: 12) {
                    Text(title)
                        .font(AppFonts.title2)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(description)
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            
            if let retryAction = retryAction {
                Button(action: retryAction) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 16, weight: .medium))
                        
                        Text("Try Again")
                            .font(AppFonts.buttonTitle)
                    }
                    .foregroundColor(AppColors.primary)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(AppColors.primary, lineWidth: 2)
                    )
                }
            }
            
            Spacer()
        }
    }
}

struct SkeletonView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(0..<5, id: \.self) { _ in
                SkeletonCard()
            }
        }
        .onAppear {
            withAnimation(
                Animation.easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: true)
            ) {
                isAnimating = true
            }
        }
    }
}

struct SkeletonCard: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppColors.primary.opacity(0.1))
                    .frame(width: 200, height: 20)
                
                Spacer()
                
                Circle()
                    .fill(AppColors.primary.opacity(0.1))
                    .frame(width: 20, height: 20)
            }
            
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.primary.opacity(0.1))
                .frame(width: 80, height: 16)
            
            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(AppColors.primary.opacity(0.1))
                    .frame(height: 12)
                
                RoundedRectangle(cornerRadius: 6)
                    .fill(AppColors.primary.opacity(0.1))
                    .frame(width: 150, height: 12)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
        )
        .opacity(isAnimating ? 0.5 : 1.0)
        .onAppear {
            withAnimation(
                Animation.easeInOut(duration: 1.0)
                    .repeatForever(autoreverses: true)
            ) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        LoadingButton(title: "Generate New Idea", isLoading: false) { }
        LoadingButton(title: "Generate New Idea", isLoading: true) { }
        
        EmptyStateView(
            icon: "heart",
            title: "No Favorites",
            description: "Your favorite ideas will appear here",
            buttonTitle: "Browse Ideas"
        ) { }
    }
    .padding()
    .background(AppColors.backgroundGradient)
}
