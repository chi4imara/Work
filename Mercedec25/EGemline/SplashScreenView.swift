import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject var appState: AppState
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    @State private var rotation: Double = 0.0
    @State private var pulseScale: CGFloat = 1.0
    @State private var innerRotation: Double = 0.0
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            GridPatternView()
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(ColorTheme.primaryBlue.opacity(0.3), lineWidth: 3)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .animation(
                            Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                            value: pulseScale
                        )
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [ColorTheme.primaryYellow, ColorTheme.primaryBlue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotation))
                        .animation(
                            Animation.linear(duration: 2).repeatForever(autoreverses: false),
                            value: rotation
                        )
                    
                    Diamond()
                        .fill(ColorTheme.accentPurple)
                        .frame(width: 30, height: 30)
                        .rotationEffect(.degrees(innerRotation))
                        .animation(
                            Animation.linear(duration: 3).repeatForever(autoreverses: false),
                            value: innerRotation
                        )
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(ColorTheme.primaryYellow)
                        .scaleEffect(scale)
                        .animation(
                            Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true),
                            value: scale
                        )
                }
                .opacity(opacity)
                .scaleEffect(scale)
                
                VStack(spacing: 8) {
                    Text("JewelMate")
                        .font(.playfairDisplay(32, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                        .opacity(opacity)
                    
                    Text("Finding your perfect jewelry...")
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(ColorTheme.secondaryText)
                        .opacity(opacity * 0.8)
                }
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeOut(duration: 1.0)) {
            scale = 1.0
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
            rotation = 360
        }
        
        withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
            innerRotation = -360
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.2
        }
        
        withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
            scale = 1.1
        }
    }
}

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: width / 2, y: 0))
        path.addLine(to: CGPoint(x: width, y: height / 2))
        path.addLine(to: CGPoint(x: width / 2, y: height))
        path.addLine(to: CGPoint(x: 0, y: height / 2))
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    SplashScreenView()
        .environmentObject(AppState())
}
