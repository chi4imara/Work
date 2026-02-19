import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = true
    @State private var scale = 0.5
    @State private var opacity = 0.0
    @State private var rotationAngle = 0.0
    @State private var pulseScale = 1.0
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(ColorManager.primaryBlue.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .opacity(opacity)
                    
                    Circle()
                        .stroke(ColorManager.primaryYellow, lineWidth: 6)
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                        .opacity(opacity)
                    
                    ZStack {
                        ForEach(0..<8, id: \.self) { index in
                            Circle()
                                .fill(ColorManager.primaryBlue)
                                .frame(width: 8, height: 8)
                                .offset(y: -25)
                                .rotationEffect(.degrees(Double(index) * 45))
                                .opacity(isAnimating ? 1.0 : 0.3)
                                .animation(
                                    Animation.easeInOut(duration: 0.8)
                                        .repeatForever()
                                        .delay(Double(index) * 0.1),
                                    value: isAnimating
                                )
                        }
                    }
                    .rotationEffect(.degrees(rotationAngle * 0.5))
                    
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(ColorManager.primaryYellow)
                        .scaleEffect(scale)
                        .opacity(opacity)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Text("Preparing your energy space...")
                        .font(FontManager.regular(size: 16))
                        .foregroundColor(ColorManager.primaryBlue)
                        .opacity(opacity)
                    
                    HStack(spacing: 4) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(ColorManager.primaryBlue)
                                .frame(width: 6, height: 6)
                                .opacity(isAnimating ? 1.0 : 0.3)
                                .animation(
                                    Animation.easeInOut(duration: 0.6)
                                        .repeatForever()
                                        .delay(Double(index) * 0.2),
                                    value: isAnimating
                                )
                        }
                    }
                    .opacity(opacity)
                }
                .padding(.bottom, 60)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeOut(duration: 0.8)) {
            opacity = 1.0
            scale = 1.0
        }
        
        withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            pulseScale = 1.3
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isAnimating = true
        }
    }
}

#Preview {
    SplashScreen()
}
