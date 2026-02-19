import SwiftUI

struct SplashScreen: View {
    @State private var isLoading = true
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var orbitsRotation: Double = 0
    @Binding var showSplash: Bool
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(
                            AngularGradient(
                                colors: [
                                    ColorTheme.accentOrange,
                                    ColorTheme.accentOrange.opacity(0.3),
                                    Color.clear,
                                    ColorTheme.accentOrange.opacity(0.6)
                                ],
                                center: .center
                            ),
                            lineWidth: 4
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    ColorTheme.accentOrange.opacity(0.8),
                                    ColorTheme.accentOrange.opacity(0.4),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 40
                            )
                        )
                        .frame(width: 80, height: 80)
                        .scaleEffect(pulseScale)
                    
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(ColorTheme.primaryText)
                            .frame(width: 8, height: 8)
                            .offset(x: 50)
                            .rotationEffect(.degrees(orbitsRotation + Double(index * 120)))
                    }
                    
                    Image(systemName: "wrench.and.screwdriver")
                        .font(.system(size: 30, weight: .medium))
                        .foregroundColor(ColorTheme.primaryText)
                        .scaleEffect(pulseScale * 0.8)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Text("Loading...")
                        .font(FontManager.body(.medium))
                        .foregroundColor(ColorTheme.primaryText)
                        .opacity(0.8)
                    
                    HStack(spacing: 4) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(ColorTheme.accentOrange)
                                .frame(width: 6, height: 6)
                                .scaleEffect(pulseScale)
                                .animation(
                                    Animation.easeInOut(duration: 0.6)
                                        .repeatForever()
                                        .delay(Double(index) * 0.2),
                                    value: pulseScale
                                )
                        }
                    }
                }
                .padding(.bottom, 80)
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                showSplash = false
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(
            Animation.linear(duration: 2.0)
                .repeatForever(autoreverses: false)
        ) {
            rotationAngle = 360
        }
        
        withAnimation(
            Animation.easeInOut(duration: 1.0)
                .repeatForever(autoreverses: true)
        ) {
            pulseScale = 1.2
        }
        
        withAnimation(
            Animation.linear(duration: 3.0)
                .repeatForever(autoreverses: false)
        ) {
            orbitsRotation = 360
        }
    }
}

#Preview {
    SplashScreen(showSplash: .constant(true))
}
