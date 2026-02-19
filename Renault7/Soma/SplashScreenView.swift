import SwiftUI

struct SplashScreenView: View {
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var opacity: Double = 0.3

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.white,
                    Color(red: 0.6, green: 0.78, blue: 0.98).opacity(0.5),
                    Color.white,
                    Color(red: 0.4, green: 0.65, blue: 0.92).opacity(0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(ColorTheme.accentColor.opacity(0.3), lineWidth: 2)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .opacity(opacity)
                    
                    Circle()
                        .trim(from: 0.0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [ColorTheme.accentColor, ColorTheme.accentColor.opacity(0.3)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 3, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: 24))
                        .foregroundColor(ColorTheme.accentColor)
                        .scaleEffect(pulseScale * 0.8)
                }
                
                Spacer()
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.3
            opacity = 0.8
        }
    }
}

struct MainAppView: View {
    @StateObject private var dataManager = DataManager.shared
    
    var body: some View {
        Group {
            if dataManager.hasCompletedOnboarding {
                NavigationStack {
                    MainTabView()
                        .navigationBarHidden(true)
                }
            } else {
                OnboardingView()
            }
        }
        .environmentObject(dataManager)
    }
}
