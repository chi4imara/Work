import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.5
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(AppColors.lightBlue.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .stroke(AppColors.orange, lineWidth: 6)
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    ZStack {
                        ForEach(0..<8) { index in
                            Rectangle()
                                .fill(AppColors.lightBlue)
                                .frame(width: 3, height: 20)
                                .offset(y: -25)
                                .rotationEffect(.degrees(Double(index) * 45))
                        }
                    }
                    .rotationEffect(.degrees(-rotationAngle * 0.5))
                    
                    Circle()
                        .fill(AppColors.darkBlue)
                        .frame(width: 30, height: 30)
                        .overlay(
                            Circle()
                                .stroke(AppColors.primaryText, lineWidth: 2)
                        )
                }
                .scaleEffect(scale)
                .opacity(opacity)
                
                Text("Loading...")
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                    .opacity(isAnimating ? 1.0 : 0.5)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            scale = 1.0
            opacity = 1.0
        }
        
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            isAnimating = true
        }
        
        withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
    }
}

#Preview {
    SplashView()
}
