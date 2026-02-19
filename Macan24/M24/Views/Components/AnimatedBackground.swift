import SwiftUI

struct AnimatedBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(0..<8, id: \.self) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                AppColors.lightBlue.opacity(0.6),
                                AppColors.primaryBlue.opacity(0.3),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 10,
                            endRadius: 50
                        )
                    )
                    .frame(width: CGFloat.random(in: 40...80))
                    .position(
                        x: animate ? CGFloat.random(in: 50...350) : CGFloat.random(in: 50...350),
                        y: animate ? CGFloat.random(in: 100...700) : CGFloat.random(in: 100...700)
                    )
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 3...6))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.5),
                        value: animate
                    )
            }
            
            ForEach(0..<15, id: \.self) { index in
                Circle()
                    .fill(AppColors.primaryBlue.opacity(0.2))
                    .frame(width: CGFloat.random(in: 8...20))
                    .position(
                        x: animate ? CGFloat.random(in: 0...400) : CGFloat.random(in: 0...400),
                        y: animate ? CGFloat.random(in: 0...800) : CGFloat.random(in: 0...800)
                    )
                    .animation(
                        Animation.linear(duration: Double.random(in: 8...15))
                            .repeatForever(autoreverses: false)
                            .delay(Double(index) * 0.2),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    AnimatedBackground()
}
