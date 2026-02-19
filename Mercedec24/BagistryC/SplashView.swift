import SwiftUI

struct SplashView: View {
    @State private var isLoading = true
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var opacity: Double = 0.3
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.theme.gradientStart, Color.theme.gradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            GridPattern()
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                ZStack {
                    Circle()
                        .stroke(Color.theme.accentYellow.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .opacity(opacity)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            AngularGradient(
                                colors: [Color.theme.accentYellow, Color.theme.primaryWhite],
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    ZStack {
                        Circle()
                            .fill(Color.theme.primaryWhite.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "handbag.fill")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(Color.theme.accentYellow)
                    }
                }
                
                Text("Loading your perfect bags...")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(Color.theme.primaryWhite)
                    .opacity(0.8)
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isLoading = false
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.3
            opacity = 0.1
        }
    }
}

struct GridPattern: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let spacing: CGFloat = 30
        
        for x in stride(from: 0, through: rect.width, by: spacing) {
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: rect.height))
        }
        
        for y in stride(from: 0, through: rect.height, by: spacing) {
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: rect.width, y: y))
        }
        
        return path
    }
}

#Preview {
    SplashView()
}
