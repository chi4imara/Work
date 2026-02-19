import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var pulseAnimation = false
    @State private var rotationAngle: Double = 0
    @State private var scaleEffect: CGFloat = 0.8
    
    var body: some View {
        ZStack {
            GridBackgroundView()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.primaryBlue.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseAnimation ? 1.2 : 1.0)
                        .opacity(pulseAnimation ? 0.3 : 0.8)
                    
                    Circle()
                        .trim(from: 0.2, to: 0.8)
                        .stroke(
                            LinearGradient(
                                colors: [AppColors.primaryYellow, AppColors.primaryBlue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [AppColors.accentGreen, AppColors.primaryBlue],
                                center: .center,
                                startRadius: 5,
                                endRadius: 25
                            )
                        )
                        .frame(width: 40, height: 40)
                        .scaleEffect(scaleEffect)
                    
                    Circle()
                        .fill(AppColors.backgroundWhite)
                        .frame(width: 8, height: 8)
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        pulseAnimation = true
                    }
                    
                    withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                        rotationAngle = 360
                    }
                    
                    withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                        scaleEffect = 1.2
                    }
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(AppColors.primaryYellow)
                            .frame(width: 12, height: 12)
                            .scaleEffect(isAnimating ? 1.0 : 0.5)
                            .animation(
                                .easeInOut(duration: 0.6)
                                .repeatForever()
                                .delay(Double(index) * 0.2),
                                value: isAnimating
                            )
                    }
                }
                .onAppear {
                    isAnimating = true
                }
                
                Spacer()
                    .frame(height: 80)
            }
        }
        .onAppear {
            FontManager.shared.registerFonts()
        }
    }
}

struct GridBackgroundView: View {
    var body: some View {
        ZStack {
            AppColors.backgroundBlue
                .ignoresSafeArea()

            Canvas { context, size in
                let gridSize: CGFloat = 30

                for x in stride(from: 0, through: size.width, by: gridSize) {
                    var path = Path()
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: size.height))
                    context.stroke(path, with: .color(AppColors.gridWhite), lineWidth: 1)
                }

                for y in stride(from: 0, through: size.height, by: gridSize) {
                    var path = Path()
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: size.width, y: y))
                    context.stroke(path, with: .color(AppColors.gridWhite), lineWidth: 1)
                }
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    SplashScreenView()
}
