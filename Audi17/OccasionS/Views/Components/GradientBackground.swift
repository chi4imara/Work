import SwiftUI

struct GradientBackground: View {
    var body: some View {
        AppColors.backgroundGradient
            .ignoresSafeArea()
    }
}

struct AnimatedGradientBackground: View {
    @State private var animateGradient = false
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.2, green: 0.5, blue: 0.8),
                Color(red: 0.4, green: 0.6, blue: 0.9),
                Color(red: 0.5, green: 0.4, blue: 0.8),
                Color(red: 0.3, green: 0.6, blue: 0.9)
            ]),
            startPoint: animateGradient ? .topLeading : .bottomTrailing,
            endPoint: animateGradient ? .bottomTrailing : .topLeading
        )
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
        }
    }
}

#Preview {
    GradientBackground()
}