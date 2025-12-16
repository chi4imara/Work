import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var isOnboardingComplete: Bool
    
    private let pages = [
        OnboardingPage(
            title: "Count Your Streaks",
            description: "Track how many days in a row you've lived without a habit",
            imageName: "calendar.badge.checkmark"
        ),
        OnboardingPage(
            title: "Break Habits",
            description: "Like social media, sweets, or coffee. Add your habits and record your progress every day",
            imageName: "target"
        ),
        OnboardingPage(
            title: "See Your Progress",
            description: "Browse your history, save the most important ones in favorites, and group them into categories. Simple, motivating, and personal — your diary of streaks",
            imageName: "chart.line.uptrend.xyaxis"
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
                .frame(maxHeight: .infinity)
                
                VStack(spacing: 20) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.accentYellow : AppColors.textWhite.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage += 1
                            }
                        } else {
                            isOnboardingComplete = true
                        }
                    }) {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(AppColors.primaryPurple)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(AppColors.accentYellow)
                            .cornerRadius(25)
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.accentYellow)
                .padding(.bottom, 20)
            
            Text(page.title)
                .font(.ubuntu(32, weight: .bold))
                .foregroundColor(AppColors.textWhite)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Text(page.description)
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(AppColors.textWhite.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}

#Preview {
    OnboardingView(isOnboardingComplete: .constant(false))
}
