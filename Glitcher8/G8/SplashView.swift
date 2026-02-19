import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            RadialGradientBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.lightBlue.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [Color.lightBlue, Color.brightOrange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Image(systemName: "location.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.pureWhite)
                        .scaleEffect(scale)
                        .opacity(opacity)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Text("Loading...")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(.pureWhite)
                        .opacity(opacity)
                    
                    HStack(spacing: 4) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(Color.lightBlue)
                                .frame(width: 8, height: 8)
                                .scaleEffect(isAnimating ? 1.0 : 0.5)
                                .animation(
                                    .easeInOut(duration: 0.6)
                                    .repeatForever()
                                    .delay(Double(index) * 0.2),
                                    value: isAnimating
                                )
                        }
                    }
                }
                .padding(.bottom, 60)
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            isAnimating = true
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            scale = 1.2
        }
        
        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
    }
}
