import SwiftUI

struct SplashView: View {
    @State private var isLoading = true
    @State private var rotation = 0.0
    @State private var scale = 0.8
    @State private var opacity = 0.0
    @State private var pulseScale = 1.0
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GridPattern()
                .opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.primaryWhite.opacity(0.3), lineWidth: 3)
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
                            AngularGradient(
                                gradient: Gradient(colors: [
                                    AppColors.primaryYellow,
                                    AppColors.secondaryOrange,
                                    AppColors.primaryYellow
                                ]),
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotation))
                        .animation(
                            Animation.linear(duration: 2)
                                .repeatForever(autoreverses: false),
                            value: rotation
                        )
                    
                    ZStack {
                        Circle()
                            .fill(AppColors.primaryWhite.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "fork.knife")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(AppColors.primaryWhite)
                            .scaleEffect(scale)
                            .animation(
                                Animation.easeInOut(duration: 1)
                                    .repeatForever(autoreverses: true),
                                value: scale
                            )
                    }
                }
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 0.5)) {
                        opacity = 1.0
                    }
                    
                    withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        pulseScale = 1.2
                    }
                    
                    withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                        rotation = 360
                    }
                    
                    withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                        scale = 1.1
                    }
                }
                
                VStack(spacing: 8) {
                    Text("Loading...")
                        .font(AppFonts.subtitle(18))
                        .foregroundColor(AppColors.textPrimary)
                        .opacity(opacity)
                    
                    Text("Preparing your culinary journey")
                        .font(AppFonts.caption(14))
                        .foregroundColor(AppColors.textSecondary)
                        .opacity(opacity * 0.8)
                }
                
                Spacer()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeOut(duration: 0.5)) {
                    isLoading = false
                }
            }
        }
    }
}

struct GridPattern: View {
    var body: some View {
        Canvas { context, size in
            let gridSize: CGFloat = 30
            
            context.stroke(
                Path { path in
                    for x in stride(from: 0, through: size.width, by: gridSize) {
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: size.height))
                    }
                    
                    for y in stride(from: 0, through: size.height, by: gridSize) {
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: size.width, y: y))
                    }
                },
                with: .color(AppColors.primaryWhite.opacity(0.1)),
                lineWidth: 1
            )
        }
    }
}

#Preview {
    SplashView()
}
