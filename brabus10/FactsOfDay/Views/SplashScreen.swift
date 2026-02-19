import SwiftUI

struct SplashScreen: View {
    @State private var isLoading = true
    @State private var rotation1 = 0.0
    @State private var rotation2 = 0.0
    @State private var scale1 = 1.0
    @State private var scale2 = 0.8
    @State private var opacity = 0.0
    @State private var waveOffset = 0.0
    @State private var particleOffset: [CGFloat] = Array(repeating: 0, count: 8)
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    ForEach(0..<3) { index in
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        ColorTheme.primaryBlue.opacity(0.3 - Double(index) * 0.1),
                                        ColorTheme.accentYellow.opacity(0.2 - Double(index) * 0.05)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 3
                            )
                            .frame(width: 80 + CGFloat(index * 20), height: 80 + CGFloat(index * 20))
                            .rotationEffect(.degrees(rotation1 + Double(index * 60)))
                            .scaleEffect(scale1 - Double(index) * 0.1)
                    }
                    
                    ZStack {
                        Circle()
                            .trim(from: 0, to: 0.75)
                            .stroke(
                                AngularGradient(
                                    colors: [
                                        ColorTheme.primaryBlue,
                                        ColorTheme.accentYellow,
                                        ColorTheme.primaryBlue
                                    ],
                                    center: .center,
                                    angle: .degrees(rotation2)
                                ),
                                style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round)
                            )
                            .frame(width: 100, height: 100)
                            .rotationEffect(.degrees(rotation2))
                        
                        Circle()
                            .trim(from: 0, to: 0.5)
                            .stroke(
                                LinearGradient(
                                    colors: [ColorTheme.accentYellow, ColorTheme.primaryBlue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 6, lineCap: .round)
                            )
                            .frame(width: 70, height: 70)
                            .rotationEffect(.degrees(-rotation1))
                    }
                    
                    ZStack {
                        ForEach(0..<8) { index in
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            ColorTheme.accentYellow.opacity(0.8),
                                            ColorTheme.primaryBlue.opacity(0.6)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 8, height: 8)
                                .offset(
                                    x: cos(Double(index) * .pi / 4 + particleOffset[index]) * 50,
                                    y: sin(Double(index) * .pi / 4 + particleOffset[index]) * 50
                                )
                                .scaleEffect(scale2)
                        }
                        
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        ColorTheme.accentYellow,
                                        ColorTheme.primaryBlue.opacity(0.3)
                                    ],
                                    center: .center,
                                    startRadius: 5,
                                    endRadius: 20
                                )
                            )
                            .frame(width: 16, height: 16)
                            .scaleEffect(scale1)
                    }
                    
                    WaveShape(waveOffset: waveOffset)
                        .stroke(
                            LinearGradient(
                                colors: [ColorTheme.primaryBlue.opacity(0.4), ColorTheme.accentYellow.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                        .frame(width: 100, height: 100)
                        .animation(
                            Animation.linear(duration: 2)
                                .repeatForever(autoreverses: false),
                            value: waveOffset
                        )
                }
                .frame(width: 200, height: 200)
                .opacity(opacity)
                .animation(.easeIn(duration: 0.5), value: opacity)
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeOut(duration: 0.5)) {
                    isLoading = false
                }
            }
        }
    }
    
    private func startAnimations() {
        opacity = 1.0
        
        withAnimation(
            Animation.linear(duration: 3)
                .repeatForever(autoreverses: false)
        ) {
            rotation1 = 360
        }
        
        withAnimation(
            Animation.linear(duration: 2)
                .repeatForever(autoreverses: false)
        ) {
            rotation2 = -360
        }
        
        withAnimation(
            Animation.easeInOut(duration: 1.2)
                .repeatForever(autoreverses: true)
        ) {
            scale1 = 1.2
            scale2 = 1.0
        }
        
        withAnimation(
            Animation.linear(duration: 2)
                .repeatForever(autoreverses: false)
        ) {
            waveOffset = 360
        }
        
        for index in particleOffset.indices {
            withAnimation(
                Animation.easeInOut(duration: 1.5 + Double(index) * 0.2)
                    .repeatForever(autoreverses: true)
            ) {
                particleOffset[index] = .pi * 2
            }
        }
    }
    
    var isLoadingBinding: Binding<Bool> {
        Binding(
            get: { isLoading },
            set: { isLoading = $0 }
        )
    }
}

struct WaveShape: Shape {
    var waveOffset: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 - 5
        
        for angle in stride(from: 0.0, through: 360.0, by: 5.0) {
            let angleInRadians = (angle + waveOffset) * .pi / 180.0
            let waveAmplitude = sin(angleInRadians * 2) * 5
            let x = center.x + radius * cos(angleInRadians)
            let y = center.y + radius * sin(angleInRadians) + waveAmplitude
            
            if angle == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        return path
    }
}
