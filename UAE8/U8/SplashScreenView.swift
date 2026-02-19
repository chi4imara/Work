import SwiftUI

struct SplashScreenView: View {
    @State private var isLoading = true
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.6
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(scale)
                        .opacity(opacity)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [ColorManager.lightBlue, ColorManager.orange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(ColorManager.white)
                        .frame(width: 12, height: 12)
                        .scaleEffect(scale)
                }
                
                Text("Loading...")
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                    .opacity(opacity)
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isLoading = false
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            scale = 1.2
            opacity = 1.0
        }
    }
}
