import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appState: AppStateManager
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPageView(
                        imageName: "lungs",
                        title: "Breathe Better. Relax Deeper.",
                        description: "This app guides you through simple breathing cycles for calm, focus, and relaxation."
                    )
                    .tag(0)
                    
                    OnboardingPageView(
                        imageName: "timer",
                        title: "Choose Your Rhythm",
                        description: "Choose a ready program or create your own, start the timer, and follow the rhythm of inhale and exhale."
                    )
                    .tag(1)
                    
                    OnboardingPageView(
                        imageName: "chart.line.uptrend.xyaxis",
                        title: "Track Your Progress",
                        description: "Track your past sessions in history and repeat your favorite routines whenever you want. Simple, clear, and effective — your personal breathing companion."
                    )
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(currentPage == index ? AppColors.primaryPurple : AppColors.lightGray)
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                .padding(.bottom, 40)
                
                Button(action: {
                    if currentPage < 2 {
                        withAnimation(.easeInOut) {
                            currentPage += 1
                        }
                    } else {
                        appState.completeOnboarding()
                    }
                }) {
                    Text(currentPage < 2 ? "Next" : "Get Started")
                        .font(.playfairDisplay(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(AppColors.purpleGradient)
                        .cornerRadius(28)
                        .shadow(color: AppColors.primaryPurple.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPageView: View {
    let imageName: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 120, height: 120)
                    .shadow(color: AppColors.primaryPurple.opacity(0.2), radius: 20, x: 0, y: 10)
                
                Image(systemName: imageName)
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(AppColors.primaryPurple)
            }
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(AppColors.darkText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(description)
                    .font(.playfairDisplay(size: 16, weight: .regular))
                    .foregroundColor(AppColors.mediumText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    OnboardingView(appState: AppStateManager())
}
