import SwiftUI

struct SettingsHeader: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(AppColors.primaryBlue.opacity(0.1))
                    .frame(width: 100, height: 100)
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                    .opacity(isAnimating ? 0.3 : 0.6)
                
                Circle()
                    .fill(AppColors.primaryYellow.opacity(0.1))
                    .frame(width: 80, height: 80)
                    .scaleEffect(isAnimating ? 0.8 : 1.1)
                    .opacity(isAnimating ? 0.4 : 0.7)
                
                ZStack {
                    Circle()
                        .fill(AppGradients.buttonGradient)
                        .frame(width: 80, height: 80)
                        .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    Image(systemName: "gear")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                }
            }
            
            VStack(spacing: 8) {
                Text("Settings")
                    .font(.playfairDisplay(28, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Customize your experience")
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    SettingsHeader()
        .background(AnimatedBackground())
}
