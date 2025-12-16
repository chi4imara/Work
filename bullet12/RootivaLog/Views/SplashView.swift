import SwiftUI

struct SplashView: View {
    @State private var isLoading = true
    @State private var logoOpacity: Double = 0
    @State private var logoScale: CGFloat = 0.5
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(AppColors.cardBackground)
                        .frame(width: 120, height: 120)
                        .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 50))
                        .foregroundColor(AppColors.primaryBlue)
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
                
                Spacer()
                
                LoadingSpinner()
                
                Spacer()
            }
        }
        .onAppear {
            startSplashAnimation()
        }
    }
    
    private func startSplashAnimation() {
        withAnimation(.easeOut(duration: 0.8)) {
            logoOpacity = 1.0
            logoScale = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                isLoading = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            }
        }
    }
}
