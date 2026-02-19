import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.5
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(Color.theme.textWhite.opacity(0.3), lineWidth: 2)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .stroke(Color.theme.accentYellow, lineWidth: 4)
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(Color.theme.textWhite)
                        .frame(width: 40, height: 40)
                        .scaleEffect(scale)
                        .opacity(opacity)
                    
                    Image(systemName: "creditcard.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color.theme.primaryPink)
                        .scaleEffect(scale)
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        isAnimating = true
                        scale = 1.0
                        opacity = 1.0
                    }
                    
                    withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                        rotationAngle = 360
                    }
                }
                
                Text("Loading...")
                    .font(.lumierepolis(18, weight: .light))
                    .foregroundColor(Color.theme.textWhite)
                    .opacity(opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                }
            }
        }
    }
}
