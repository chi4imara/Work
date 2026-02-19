import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.3
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(
                            AngularGradient(
                                colors: [
                                    Color.theme.primaryBlue,
                                    Color.theme.primaryYellow,
                                    Color.theme.accentOrange,
                                    Color.theme.primaryBlue
                                ],
                                center: .center
                            ),
                            lineWidth: 8
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: rotationAngle)
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.theme.primaryYellow.opacity(0.8),
                                    Color.theme.primaryBlue.opacity(0.4),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 10,
                                endRadius: 50
                            )
                        )
                        .frame(width: 80, height: 80)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: scale)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: opacity)
                    
                    Circle()
                        .fill(Color.theme.primaryBlue)
                        .frame(width: 30, height: 30)
                        .shadow(color: Color.theme.primaryBlue.opacity(0.5), radius: 10, x: 0, y: 0)
                    
                    ForEach(0..<6, id: \.self) { index in
                        Circle()
                            .fill(Color.theme.primaryYellow)
                            .frame(width: 12, height: 12)
                            .offset(
                                x: cos(Double(index) * .pi / 3 + rotationAngle * .pi / 180) * 70,
                                y: sin(Double(index) * .pi / 3 + rotationAngle * .pi / 180) * 70
                            )
                            .opacity(0.7)
                            .animation(.linear(duration: 3).repeatForever(autoreverses: false), value: rotationAngle)
                    }
                }
                
                Spacer()
                
                Text("Loading your career journey...")
                    .font(.custom("PlayfairDisplay-Medium", size: 18))
                    .foregroundColor(Color.theme.primaryBlue)
                    .opacity(isAnimating ? 1.0 : 0.3)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isAnimating)
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation {
            rotationAngle = 360
        }
        
        withAnimation {
            scale = 1.2
            opacity = 0.8
        }
        
        withAnimation {
            isAnimating = true
        }
    }
}

#Preview {
    SplashScreen()
}
