import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let backgroundWhite = Color.white
    
    static let softPink = Color(red: 1.0, green: 0.7, blue: 0.8)
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.95)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    static let accentPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    
    static let primaryText = primaryBlue
    static let secondaryText = Color(red: 0.5, green: 0.5, blue: 0.5)
    static let contrastText = Color.black
    
    static let gradientStart = Color(red: 0.98, green: 0.99, blue: 1.0)
    static let gradientEnd = Color(red: 0.95, green: 0.97, blue: 1.0)
    
    static let orb1 = primaryBlue.opacity(0.3)
    static let orb2 = primaryYellow.opacity(0.2)
    static let orb3 = softPink.opacity(0.25)
    static let orb4 = accentPurple.opacity(0.2)
}

struct AnimatedBackground: View {
    @State private var orb1Offset = CGSize.zero
    @State private var orb2Offset = CGSize.zero
    @State private var orb3Offset = CGSize.zero
    @State private var orb4Offset = CGSize.zero
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [AppColors.gradientStart, AppColors.gradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            GeometryReader { geometry in
                Circle()
                    .fill(AppColors.orb1)
                    .frame(width: 120, height: 120)
                    .offset(x: orb1Offset.width, y: orb1Offset.height)
                    .position(x: geometry.size.width * 0.2, y: geometry.size.height * 0.3)
                
                Circle()
                    .fill(AppColors.orb2)
                    .frame(width: 80, height: 80)
                    .offset(x: orb2Offset.width, y: orb2Offset.height)
                    .position(x: geometry.size.width * 0.8, y: geometry.size.height * 0.2)
                
                Circle()
                    .fill(AppColors.orb3)
                    .frame(width: 100, height: 100)
                    .offset(x: orb3Offset.width, y: orb3Offset.height)
                    .position(x: geometry.size.width * 0.7, y: geometry.size.height * 0.7)
                
                Circle()
                    .fill(AppColors.orb4)
                    .frame(width: 60, height: 60)
                    .offset(x: orb4Offset.width, y: orb4Offset.height)
                    .position(x: geometry.size.width * 0.3, y: geometry.size.height * 0.8)
            }
        }
        .onAppear {
            startOrbAnimation()
        }
    }
    
    private func startOrbAnimation() {
        withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
            orb1Offset = CGSize(width: 30, height: -40)
        }
        
        withAnimation(.easeInOut(duration: 3.5).repeatForever(autoreverses: true).delay(0.5)) {
            orb2Offset = CGSize(width: -25, height: 35)
        }
        
        withAnimation(.easeInOut(duration: 4.5).repeatForever(autoreverses: true).delay(1)) {
            orb3Offset = CGSize(width: 40, height: -30)
        }
        
        withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true).delay(1.5)) {
            orb4Offset = CGSize(width: -35, height: 25)
        }
    }
}
