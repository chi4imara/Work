import SwiftUI

struct SplashView: View {
    @State private var isLoading = true
    @State private var rotation = 0.0
    @State private var scale = 0.8
    @State private var opacity = 0.0
    @State private var pulseScale = 1.0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [Color.theme.primaryBlue, Color.theme.primaryYellow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 4
                        )
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .opacity(0.6)
                    
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(Color.theme.primaryBlue.opacity(0.8))
                            .frame(width: 12, height: 12)
                            .offset(y: -40)
                            .rotationEffect(.degrees(rotation + Double(index * 120)))
                    }
                    
                    Circle()
                        .fill(Color.theme.primaryYellow)
                        .frame(width: 20, height: 20)
                        .scaleEffect(scale)
                }
                .opacity(opacity)
                
                Spacer()
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
        withAnimation(.easeInOut(duration: 0.8)) {
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotation = 360
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.2
        }
        
        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            scale = 1.2
        }
    }
}
