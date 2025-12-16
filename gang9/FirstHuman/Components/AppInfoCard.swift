import SwiftUI

struct AppInfoCard: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColors.primaryBlue.opacity(0.1))
                    .frame(width: 80, height: 80)
                    .scaleEffect(isAnimating ? 1.1 : 0.9)
                    .opacity(isAnimating ? 0.3 : 0.6)
                
                Image(systemName: "leaf.circle")
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(AppColors.primaryBlue)
                    .scaleEffect(isAnimating ? 1.05 : 1.0)
            }
            
            VStack(spacing: 8) {
                Text("Solitude Companion")
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Find stillness in your own thoughts")
                    .font(.playfairDisplayItalic(16, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppGradients.cardGradient)
                .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    AppInfoCard()
        .background(AnimatedBackground())
}
