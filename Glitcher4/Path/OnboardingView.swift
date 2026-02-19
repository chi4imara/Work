import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    let onOnboardingComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            title: "Track your endurance sessions.",
            description: "Record your running, cycling or swimming sessions with clear details. Log distances, durations and notes to follow your endurance progress over time. Keep your training history structured and always know how each session went.",
            imageName: "figure.run"
        ),
        OnboardingPage(
            title: "Monitor your progress.",
            description: "View comprehensive statistics about your training. Track total distance, duration, and discover your best sessions. Analyze your performance trends and stay motivated to achieve your fitness goals.",
            imageName: "chart.bar.fill"
        ),
        OnboardingPage(
            title: "Stay organized and motivated.",
            description: "Keep all your workouts in one place. Edit or delete entries anytime. Review your training journal to see how far you've come and plan your next endurance challenge.",
            imageName: "book.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 30) {
                    if pages.count > 1 {
                        HStack(spacing: 8) {
                            ForEach(0..<pages.count, id: \.self) { index in
                                Circle()
                                    .fill(index == currentPage ? AppColors.lightBlue : AppColors.white.opacity(0.3))
                                    .frame(width: 8, height: 8)
                                    .scaleEffect(index == currentPage ? 1.2 : 1.0)
                                    .animation(.easeInOut(duration: 0.3), value: currentPage)
                            }
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentPage += 1
                            }
                        } else {
                            onOnboardingComplete()
                        }
                    }) {
                        HStack {
                            Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(AppColors.white)
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppColors.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [AppColors.lightBlue, AppColors.orange],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(28)
                        .scaleEffect(isAnimating ? 1.05 : 1.0)
                    }
                    .padding(.horizontal, 32)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                            isAnimating = true
                        }
                    }
                }
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var isVisible = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.lightBlue)
                .scaleEffect(isVisible ? 1.0 : 0.5)
                .opacity(isVisible ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.8).delay(0.2), value: isVisible)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.white)
                    .multilineTextAlignment(.center)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .offset(y: isVisible ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: isVisible)
                
                Text(page.description)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .offset(y: isVisible ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: isVisible)
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
        .onAppear {
            isVisible = true
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}

#Preview {
    OnboardingView(onOnboardingComplete: {})
}
