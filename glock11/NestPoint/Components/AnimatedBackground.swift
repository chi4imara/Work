import SwiftUI

struct AnimatedBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(0..<6, id: \.self) { index in
                Circle()
                    .fill(ColorTheme.lightBlue.opacity(0.3))
                    .frame(width: CGFloat.random(in: 20...60))
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
            
            ForEach(0..<8, id: \.self) { index in
                Circle()
                    .fill(ColorTheme.primaryBlue.opacity(0.1))
                    .frame(width: CGFloat.random(in: 10...30))
                    .position(
                        x: animate ? CGFloat.random(in: 30...380) : CGFloat.random(in: 30...380),
                        y: animate ? CGFloat.random(in: 50...750) : CGFloat.random(in: 50...750)
                    )
                    .animation(
                        Animation.linear(duration: Double.random(in: 4...8))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.3),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct AnimatedBackground_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedBackground()
    }
}
