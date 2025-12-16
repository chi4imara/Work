import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            ColorManager.shared.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .stroke(ColorManager.shared.primaryPurple.opacity(0.3), lineWidth: 2)
                            .frame(width: 120 + CGFloat(index * 20), height: 120 + CGFloat(index * 20))
                            .scaleEffect(isAnimating ? 1.2 : 0.8)
                            .opacity(isAnimating ? 0.1 : 0.6)
                            .animation(
                                Animation.easeInOut(duration: 2.0)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.3),
                                value: isAnimating
                            )
                    }
                    
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    ColorManager.shared.primaryPurple,
                                    ColorManager.shared.primaryBlue
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .rotationEffect(.degrees(rotationAngle))
                        .shadow(color: ColorManager.shared.primaryPurple.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    Circle()
                        .stroke(
                            ColorManager.shared.primaryYellow,
                            style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [10, 5])
                        )
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(-rotationAngle * 1.5))
                        .opacity(0.8)
                    
                    Circle()
                        .fill(ColorManager.shared.primaryYellow)
                        .frame(width: 12, height: 12)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .animation(
                            Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                }
                
                Spacer()
                
                Text("Loading...")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorManager.shared.primaryBlue)
                    .opacity(opacity)
                
                Spacer().frame(height: 80)
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 1.0)) {
            isAnimating = true
            scale = 1.0
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
    }
}

