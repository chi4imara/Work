import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var isComplete: Bool
    
    private let pages = [
        OnboardingPage(
            title: "Keep track of your hair care journey.",
            description: "Save every hair care procedure, note the date, add details, and mark the effect you noticed.",
            imageName: "sparkles",
            backgroundColor: Color.blue.opacity(0.8)
        ),
        OnboardingPage(
            title: "Build your routine step by step",
            description: "Understand what actually works for you. Stay organized and keep your hair care history in one clean, simple place.",
            imageName: "chart.line.uptrend.xyaxis",
            backgroundColor: AppColors.accentYellow.opacity(0.8)
        ),
        OnboardingPage(
            title: "Track your progress",
            description: "Analyze your hair care journey with detailed statistics and insights about what works best for your hair.",
            imageName: "chart.bar.fill",
            backgroundColor: AppColors.successGreen.opacity(0.8)
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Hair Care Guide")
                        .font(.bellGothic(24, weight: .bold))
                        .foregroundColor(AppColors.primaryWhite)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? AppColors.accentYellow : AppColors.primaryWhite.opacity(0.4))
                            .frame(width: 10, height: 10)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: currentPage)
                    }
                }
                .padding(.bottom, 30)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    } else {
                        isComplete = true
                        UserDefaults.standard.set(true, forKey: "HasSeenOnboarding")
                    }
                }) {
                    Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                        .font(.bellGothic(18, weight: .bold))
                        .foregroundColor(AppColors.primaryWhite)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(AppColors.accentYellow)
                        )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
    let backgroundColor: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(page.backgroundColor.opacity(0.2))
                    .frame(width: 150, height: 150)
                
                Image(systemName: page.imageName)
                    .font(.system(size: 60, weight: .medium))
                    .foregroundColor(page.backgroundColor)
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.bellGothic(28, weight: .bold))
                    .foregroundColor(AppColors.primaryWhite)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(.bellGothic(16, weight: .regular))
                    .foregroundColor(AppColors.primaryWhite.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}
