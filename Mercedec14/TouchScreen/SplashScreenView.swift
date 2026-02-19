import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject var appState: AppStateManager
    @State private var loadingProgress: Double = 0.0
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0
    @State private var circleOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [ColorTheme.primaryBlue.opacity(0.3), ColorTheme.primaryYellow.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 4
                        )
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .animation(
                            .easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                            value: pulseScale
                        )
                    
                    Circle()
                        .trim(from: 0, to: loadingProgress)
                        .stroke(
                            LinearGradient(
                                colors: [ColorTheme.primaryBlue, ColorTheme.primaryYellow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(.linear(duration: 2.0).repeatForever(autoreverses: false), value: rotationAngle)
                    
                    ForEach([0, 1, 2], id: \.self) { index in
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [ColorTheme.primaryBlue, ColorTheme.primaryYellow],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 12, height: 12)
                            .opacity(0.8)
                    }
                    
                    Circle()
                        .fill(ColorTheme.primaryYellow)
                        .frame(width: 8, height: 8)
                        .scaleEffect(pulseScale * 0.8)
                }
                
                VStack(spacing: 12) {
                    Text("RelaxMe")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(ColorTheme.primaryBlue)
                        .opacity(0.9)
                    
                    Text("Preparing your wellness journey...")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    SwiftUI.ProgressView(value: min(1.0, max(0, loadingProgress)), total: 1.0)
                        .progressViewStyle(CustomProgressViewStyle())
                        .frame(width: 200)
                    
                    Text("\(Int((min(1.0, max(0, loadingProgress)) * 100)))%")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary)
                }
                .padding(.bottom, 50)
            }
            .padding(.horizontal, 40)
        }
        .onAppear {
            startLoadingAnimation()
        }
    }
    
    private func startLoadingAnimation() {
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.2
        }
        
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
    }
    
    private func startProgressAnimation() {
        let timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            DispatchQueue.main.async {
                if loadingProgress < 1.0 {
                    loadingProgress = min(1.0, loadingProgress + 0.02)
                }
                if loadingProgress >= 1.0 {
                    timer.invalidate()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeOut(duration: 0.5)) {
                            appState.completeSplashScreen()
                        }
                    }
                }
            }
        }
        timer.fire()
    }
}

struct CustomProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(ColorTheme.primaryBlue.opacity(0.2))
                    .frame(height: 8)
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [ColorTheme.primaryBlue, ColorTheme.primaryYellow],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(
                        width: geometry.size.width * CGFloat(configuration.fractionCompleted ?? 0),
                        height: 8
                    )
                    .animation(.easeInOut(duration: 0.3), value: configuration.fractionCompleted)
            }
        }
    }
}
