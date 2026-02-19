import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.5
    @State private var rotationAngle: Double = 0
    @Binding var isActive: Bool
    
    var body: some View {
        ZStack {
            AppColors.primaryBackground
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(AppColors.lightBlue, lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(AppColors.orange, lineWidth: 6)
                        .frame(width: 90, height: 90)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(AppColors.lightBlue.opacity(0.3))
                        .frame(width: 60, height: 60)
                        .scaleEffect(scale)
                        .opacity(opacity)
                    
                    Circle()
                        .fill(AppColors.orange)
                        .frame(width: 20, height: 20)
                        .scaleEffect(isAnimating ? 1.5 : 1.0)
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        isAnimating = true
                        scale = 1.2
                        opacity = 1.0
                    }
                    
                    withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                        rotationAngle = 360
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isActive = false
                }
            }
        }
    }
}

#Preview {
    SplashScreen(isActive: .constant(true))
}
