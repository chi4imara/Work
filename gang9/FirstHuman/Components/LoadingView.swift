import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(AppColors.primaryBlue.opacity(0.3), lineWidth: 4)
                    .frame(width: 50, height: 50)
                
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(AppColors.primaryBlue, lineWidth: 4)
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
            }
            
            Text("Loading...")
                .font(.playfairDisplay(16, weight: .medium))
                .foregroundColor(AppColors.textSecondary)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    LoadingView()
        .background(AnimatedBackground())
}
