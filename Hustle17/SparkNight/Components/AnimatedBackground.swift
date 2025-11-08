import SwiftUI

struct AnimatedBackground: View {
    @State private var animationOffset: CGFloat = 0
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                ZStack {
                    ForEach(0..<8, id: \.self) { index in
                        Path { path in
                            let startX = CGFloat(index) * geometry.size.width / 8 + animationOffset
                            let endX = startX + geometry.size.width / 4
                            
                            path.move(to: CGPoint(x: startX, y: 0))
                            path.addLine(to: CGPoint(x: endX, y: geometry.size.height))
                        }
                        .stroke(
                            ColorTheme.lightBlue.opacity(0.3),
                            style: StrokeStyle(lineWidth: 1, dash: [5, 10])
                        )
                    }
                    
                    ForEach(0..<6, id: \.self) { index in
                        Path { path in
                            let y = CGFloat(index) * geometry.size.height / 6 + animationOffset / 2
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                        }
                        .stroke(
                            ColorTheme.primaryBlue.opacity(0.2),
                            style: StrokeStyle(lineWidth: 0.5, dash: [3, 8])
                        )
                    }
                    
                    ForEach(0..<5, id: \.self) { index in
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        ColorTheme.lightBlue.opacity(0.4),
                                        ColorTheme.primaryBlue.opacity(0.1)
                                    ],
                                    center: .center,
                                    startRadius: 5,
                                    endRadius: 30
                                )
                            )
                            .frame(width: 60, height: 60)
                            .scaleEffect(pulseScale)
                            .position(
                                x: geometry.size.width * CGFloat(index) / 5 + 50,
                                y: geometry.size.height * 0.3 + CGFloat(index * 40) + animationOffset / 3
                            )
                    }
                }
            }
            .onAppear {
                withAnimation(
                    Animation.linear(duration: 20)
                        .repeatForever(autoreverses: false)
                ) {
                    animationOffset = 200
                }
                
                withAnimation(
                    Animation.easeInOut(duration: 3)
                        .repeatForever(autoreverses: true)
                ) {
                    pulseScale = 1.2
                }
            }
        }
    }
}

struct StaticBackground: View {
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    ColorTheme.lightBlue.opacity(0.3),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 10,
                                endRadius: 100
                            )
                        )
                        .frame(width: 200, height: 200)
                        .position(x: -50, y: -50)
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    ColorTheme.primaryBlue.opacity(0.2),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 20,
                                endRadius: 120
                            )
                        )
                        .frame(width: 240, height: 240)
                        .position(x: geometry.size.width + 50, y: geometry.size.height + 50)
                }
            }
        }
    }
}

#Preview {
    AnimatedBackground()
}
