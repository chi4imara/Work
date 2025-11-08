import SwiftUI

struct SplashScreenView: View {
    @State private var isLoading = true
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.5
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    
    var onComplete: () -> Void
    
    var body: some View {
        ZStack {
            AppGradient.background
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.primaryAccent.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: pulseScale
                        )
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            Color.primaryAccent,
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(
                            Animation.linear(duration: 1)
                                .repeatForever(autoreverses: false),
                            value: rotationAngle
                        )
                    
                    ZStack {
                        Circle()
                            .fill(Color.primaryAccent)
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "sportscourt")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .scaleEffect(scale)
                    .opacity(opacity)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Text("Loading...")
                        .font(.headline)
                        .foregroundColor(.primaryText)
                    
                    HStack(spacing: 4) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(Color.primaryAccent)
                                .frame(width: 8, height: 8)
                                .scaleEffect(getDotScale(for: index))
                                .animation(
                                    Animation.easeInOut(duration: 0.6)
                                        .repeatForever()
                                        .delay(Double(index) * 0.2),
                                    value: isLoading
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
                withAnimation(.easeInOut(duration: 0.5)) {
                    onComplete()
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 1.0)) {
            scale = 1.0
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.2
        }
    }
    
    private func getDotScale(for index: Int) -> CGFloat {
        let delay = Double(index) * 0.2
        let time = Date().timeIntervalSince1970.truncatingRemainder(dividingBy: 1.8)
        let adjustedTime = (time - delay).truncatingRemainder(dividingBy: 1.8)
        
        if adjustedTime < 0.3 {
            return 1.0 + (adjustedTime / 0.3) * 0.5
        } else if adjustedTime < 0.6 {
            return 1.5 - ((adjustedTime - 0.3) / 0.3) * 0.5
        } else {
            return 1.0
        }
    }
}

#Preview {
    SplashScreenView {
        print("Splash completed")
    }
}
