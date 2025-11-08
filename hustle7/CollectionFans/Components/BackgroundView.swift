import SwiftUI

struct BackgroundView: View {
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.backgroundWhite,
                    Color.backgroundGray,
                    Color.lightBlue.opacity(0.3)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            ForEach(0..<15, id: \.self) { index in
                Circle()
                    .fill(Color.primaryBlue.opacity(0.1))
                    .frame(width: CGFloat.random(in: 20...60))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height) + animationOffset
                    )
                    .animation(
                        Animation.linear(duration: Double.random(in: 10...20))
                            .repeatForever(autoreverses: false),
                        value: animationOffset
                    )
            }
            
            ForEach(0..<8, id: \.self) { index in
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.lightBlue.opacity(0.05))
                    .frame(width: CGFloat.random(in: 30...80), height: CGFloat.random(in: 30...80))
                    .rotationEffect(.degrees(Double.random(in: 0...360)))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height) + animationOffset * 0.5
                    )
                    .animation(
                        Animation.linear(duration: Double.random(in: 15...25))
                            .repeatForever(autoreverses: false),
                        value: animationOffset
                    )
            }
        }
        .ignoresSafeArea()
        .onAppear {
            animationOffset = -UIScreen.main.bounds.height * 2
        }
    }
}

#Preview {
    BackgroundView()
}
