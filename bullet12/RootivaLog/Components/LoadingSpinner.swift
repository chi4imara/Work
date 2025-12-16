import SwiftUI

struct LoadingSpinner: View {
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    @State private var pulseOpacity: Double = 0.3
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(AppColors.primaryBlue.opacity(pulseOpacity), lineWidth: 3)
                .frame(width: 80, height: 80)
                .scaleEffect(scale)
            
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [AppColors.primaryBlue, AppColors.primaryYellow]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                )
                .frame(width: 60, height: 60)
                .rotationEffect(.degrees(rotation))
            
            Circle()
                .fill(AppColors.accentYellow)
                .frame(width: 12, height: 12)
                .scaleEffect(scale * 0.8)
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(
            Animation.linear(duration: 1.5)
                .repeatForever(autoreverses: false)
        ) {
            rotation = 360
        }
        
        withAnimation(
            Animation.easeInOut(duration: 1.0)
                .repeatForever(autoreverses: true)
        ) {
            scale = 1.2
        }
        
        withAnimation(
            Animation.easeInOut(duration: 0.8)
                .repeatForever(autoreverses: true)
        ) {
            pulseOpacity = 0.8
        }
    }
}

#Preview {
    ZStack {
        AnimatedBackground()
        LoadingSpinner()
    }
}
