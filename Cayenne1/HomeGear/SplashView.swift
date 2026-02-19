import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                ForEach(0..<20, id: \.self) { index in
                    Circle()
                        .fill(AppColors.lightBlue.opacity(0.1))
                        .frame(width: 60, height: 60)
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .animation(
                            Animation.easeInOut(duration: Double.random(in: 2...4))
                                .repeatForever(autoreverses: true)
                                .delay(Double.random(in: 0...2)),
                            value: isAnimating
                        )
                }
            }
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.lightBlue.opacity(0.3), lineWidth: 8)
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            AngularGradient(
                                colors: [AppColors.lightBlue, AppColors.orange, AppColors.lightBlue],
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(rotation))
                        .animation(
                            Animation.linear(duration: 1.5).repeatForever(autoreverses: false),
                            value: rotation
                        )
                    
                    Circle()
                        .fill(AppColors.orange.opacity(0.8))
                        .frame(width: 60, height: 60)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .animation(
                            Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                            value: scale
                        )
                    
                    Circle()
                        .fill(AppColors.primaryText)
                        .frame(width: 12, height: 12)
                }
                
                Spacer()
                
                Text("Loading...")
                    .font(.playfairDisplay(18, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                    .opacity(opacity)
                    .animation(
                        Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                        value: opacity
                    )
                
                Spacer().frame(height: 100)
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeOut(duration: 0.5)) {
                }
            }
        }
    }
    
    private func startAnimations() {
        isAnimating = true
        rotation = 360
        
        withAnimation(Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
            scale = 1.2
            opacity = 1.0
        }
    }
}
