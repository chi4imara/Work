import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    @State private var animateContent = false
    
    private let pages = [
        OnboardingPage(
            title: "Shape your body and energy",
            description: "Plan personalized workouts, track progress, and maintain energy, strength, and focus every day.",
            iconName: "figure.strengthtraining.traditional",
            color: Color.yellow
        ),
        OnboardingPage(
            title: "Personalized Workouts",
            description: "Get custom workout plans based on your fitness level, goals, and preferences.",
            iconName: "person.crop.circle.badge.checkmark",
            color: ColorTheme.accentPurple
        ),
        OnboardingPage(
            title: "Track Your Progress",
            description: "Monitor your achievements, build streaks, and see your fitness journey unfold.",
            iconName: "chart.line.uptrend.xyaxis",
            color: ColorTheme.accentOrange
        )
    ]
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(
                            page: pages[index],
                            animateContent: animateContent
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                VStack(spacing: 30) {
                    HStack(spacing: 12) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? ColorTheme.primaryYellow : ColorTheme.primaryWhite.opacity(0.3))
                                .frame(width: 10, height: 10)
                                .scaleEffect(index == currentPage ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    HStack(spacing: 20) {
                        if currentPage > 0 {
                            Button("Back") {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentPage -= 1
                                }
                            }
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(ColorTheme.textSecondary)
                            .frame(maxWidth: .infinity)
                            
                            Spacer()
                        }
                        
                        
                        Button {
                            if currentPage == pages.count - 1 {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    showOnboarding = false
                                }
                            } else {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentPage += 1
                                }
                            }
                        } label: {
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Next")
                                .font(.ubuntu(14, weight: .semibold))
                                .foregroundColor(ColorTheme.primaryWhite)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(ColorTheme.primaryYellow)
                                .cornerRadius(25)
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).delay(0.2)) {
                animateContent = true
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let iconName: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let animateContent: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: page.iconName)
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(page.color)
            }
            .scaleEffect(animateContent ? 1.0 : 0.5)
            .opacity(animateContent ? 1.0 : 0.0)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                    .multilineTextAlignment(.center)
                    .offset(y: animateContent ? 0 : 30)
                    .opacity(animateContent ? 1.0 : 0.0)
                
                Text(page.description)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .offset(y: animateContent ? 0 : 30)
                    .opacity(animateContent ? 1.0 : 0.0)
            }
            
            Spacer()
            Spacer()
        }
        .animation(.easeOut(duration: 0.8).delay(0.3), value: animateContent)
    }
}
