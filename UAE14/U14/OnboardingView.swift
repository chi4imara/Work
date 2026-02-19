import SwiftUI

struct OnboardingView: View {
    @Binding var isShowingOnboarding: Bool
    @AppStorage("has_completed_onboarding") private var hasCompletedOnboarding = false
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                pageIndicator
                
                TabView(selection: $currentPage) {
                    OnboardingPage(
                        icon: "figure.strengthtraining.traditional",
                        title: "Track every pull-up, build your progress.",
                        description: "This app helps you record your pull-up results day by day and see how your performance develops over time.",
                        pageIndex: 0
                    )
                    .tag(0)
                    
                    OnboardingPage(
                        icon: "book.fill",
                        title: "Easy Entry System",
                        description: "Add entries in seconds. Record your daily pull-ups with date, count, and optional comments to track your journey.",
                        pageIndex: 1
                    )
                    .tag(1)
                    
                    OnboardingPage(
                        icon: "chart.line.uptrend.xyaxis",
                        title: "Visual Progress Tracking",
                        description: "Review your stats and follow your progress with a clean and simple graph. See your improvement over time.",
                        pageIndex: 2
                    )
                    .tag(2)
                    
                    OnboardingPage(
                        icon: "trophy.fill",
                        title: "Stay Consistent",
                        description: "Watch your numbers grow with every training day. Build habits, track achievements, and reach your goals.",
                        pageIndex: 3
                    )
                    .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                navigationButtons
            }
        }
    }
    
    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<4) { index in
                Circle()
                    .fill(index == currentPage ? AppColors.lightBlue : AppColors.cardBorder)
                    .frame(width: index == currentPage ? 10 : 8, height: index == currentPage ? 10 : 8)
                    .animation(.easeInOut(duration: 0.3), value: currentPage)
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 20)
    }
    
    private var navigationButtons: some View {
        HStack(spacing: 16) {
            if currentPage > 0 {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentPage -= 1
                    }
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .medium))
                        Text("Back")
                            .font(.ubuntu(16, weight: .medium))
                    }
                    .foregroundColor(AppColors.secondaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(AppColors.cardBackground)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
                }
            }
            
            Button(action: {
                if currentPage < 3 {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentPage += 1
                    }
                } else {
                    completeOnboarding()
                }
            }) {
                HStack {
                    Text(currentPage < 3 ? "Continue" : "Get Started")
                        .font(.ubuntu(16, weight: .bold))
                    
                    if currentPage < 3 {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .bold))
                    } else {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .bold))
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [AppColors.lightBlue, AppColors.lightBlue.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
                .shadow(color: AppColors.lightBlue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 50)
    }
    
    private func completeOnboarding() {
        hasCompletedOnboarding = true
        withAnimation(.easeInOut(duration: 0.5)) {
            isShowingOnboarding = false
        }
    }
}

struct OnboardingPage: View {
    let icon: String
    let title: String
    let description: String
    let pageIndex: Int
    
    @State private var isAnimating = false
    @State private var iconScale: CGFloat = 0.8
    @State private var iconOpacity: Double = 0.5
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .stroke(AppColors.lightBlue.opacity(0.3), lineWidth: 3)
                    .frame(width: 140, height: 140)
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                    .opacity(isAnimating ? 0.3 : 0.6)
                
                Circle()
                    .fill(AppColors.lightBlue.opacity(0.15))
                    .frame(width: 120, height: 120)
                    .scaleEffect(isAnimating ? 1.05 : 1.0)
                
                Image(systemName: icon)
                    .font(.system(size: 55, weight: .medium))
                    .foregroundColor(AppColors.lightBlue)
                    .scaleEffect(iconScale)
                    .opacity(iconOpacity)
            }
            .padding(.bottom, 20)
            
            VStack(spacing: 12) {
                Text(title)
                    .font(.ubuntu(23, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .lineSpacing(1)
                
                Text(description)
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.horizontal, 30)
            }
            
            Spacer()
            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                iconScale = 1.0
                iconOpacity = 1.0
            }
            
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    OnboardingView(isShowingOnboarding: .constant(true))
}

