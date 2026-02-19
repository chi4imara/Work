import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appState: AppStateViewModel
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    AppColors.deepBlue,
                    AppColors.darkBlue,
                    AppColors.lightBlue.opacity(0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPageView(
                        imageName: "dumbbell.fill",
                        title: "Track your strength workouts.",
                        description: "Record your strength sessions with clear notes on exercises, weight and reps. Build a simple log of your lifts, follow your progress over time and stay focused on consistent improvement.",
                        pageIndex: 0
                    )
                    .tag(0)
                    
                    OnboardingPageView(
                        imageName: "chart.line.uptrend.xyaxis",
                        title: "Monitor Your Progress",
                        description: "A clean journal made for tracking strength training day by day. Watch your numbers grow and celebrate every milestone in your fitness journey.",
                        pageIndex: 1
                    )
                    .tag(1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack(spacing: 8) {
                    ForEach(0..<2) { index in
                        Circle()
                            .fill(currentPage == index ? AppColors.lightBlue : AppColors.primaryText.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 40)
                
                Button(action: {
                    if currentPage < 1 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage += 1
                        }
                    } else {
                        appState.completeOnboarding()
                    }
                }) {
                    Text(currentPage < 1 ? "Continue" : "Get Started")
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(AppColors.primaryText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(AppColors.lightBlue)
                        )
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
    let pageIndex: Int
    
    @State private var isAnimated = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.lightBlue.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .scaleEffect(isAnimated ? 1.0 : 0.8)
                
                Image(systemName: imageName)
                    .font(.system(size: 48, weight: .medium))
                    .foregroundColor(AppColors.lightBlue)
                    .scaleEffect(isAnimated ? 1.0 : 0.8)
            }
            .animation(.easeOut(duration: 0.8).delay(0.2), value: isAnimated)
            
            VStack(spacing: 24) {
                Text(title)
                    .font(.playfairDisplay(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimated ? 1.0 : 0.0)
                    .offset(y: isAnimated ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: isAnimated)
                
                Text(description)
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .opacity(isAnimated ? 1.0 : 0.0)
                    .offset(y: isAnimated ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: isAnimated)
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
        .onAppear {
            isAnimated = true
        }
        .onChange(of: pageIndex) { _ in
            isAnimated = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isAnimated = true
            }
        }
    }
}

#Preview {
    OnboardingView(appState: AppStateViewModel())
}
