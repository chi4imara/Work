import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var hasCompletedOnboarding: Bool
    
    let pages = [
        OnboardingPage(
            image: "book.circle.fill",
            title: "Track Your Reading",
            description: "Keep a personal reading diary and never lose track of your progress."
        ),
        OnboardingPage(
            image: "chart.line.uptrend.xyaxis.circle.fill",
            title: "See Your Progress",
            description: "Watch your reading journey grow with detailed statistics and insights."
        ),
        OnboardingPage(
            image: "target",
            title: "Achieve Your Goals",
            description: "Add books you're reading, record daily pages, and celebrate completions."
        )
    ]
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
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
                            .fill(currentPage == index ? AppColors.primaryYellow : AppColors.primaryText.opacity(0.3))
                            .frame(width: 10, height: 10)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3), value: currentPage)
                    }
                }
                .padding(.vertical, 20)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    } else {
                        hasCompletedOnboarding = true
                    }
                }) {
                    Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(AppColors.primaryBlue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(AppColors.primaryYellow)
                        )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
                
                if currentPage < pages.count - 1 {
                    Button("Skip") {
                        hasCompletedOnboarding = true
                    }
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.primaryText.opacity(0.7))
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.image)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryYellow)
                .padding(.bottom, 20)
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}

struct OnboardingPage {
    let image: String
    let title: String
    let description: String
}

#Preview {
    OnboardingView(hasCompletedOnboarding: .constant(false))
}
