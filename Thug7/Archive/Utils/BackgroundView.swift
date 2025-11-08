import SwiftUI

struct BackgroundView: View {
    @State private var circleOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            AppTheme.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(0..<6, id: \.self) { index in
                Circle()
                    .fill(AppTheme.lightBlue.opacity(0.3))
                    .frame(width: CGFloat.random(in: 50...120))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .offset(x: circleOffset * CGFloat(index % 2 == 0 ? 1 : -1))
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 3...6))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.5),
                        value: circleOffset
                    )
            }
        }
    }
}

#Preview {
    BackgroundView()
}
