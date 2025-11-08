import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var isOnboardingCompleted: Bool
    
    private let pages = [
        OnboardingPage(
            image: "gift.fill",
            title: "Gift Manager",
            subtitle: "Remember Every Idea",
            description: "Store your gift ideas organized by people. Never forget a perfect gift idea again."
        ),
        OnboardingPage(
            image: "person.3.fill",
            title: "Organize by People",
            subtitle: "Keep Track of Everyone",
            description: "Add people and categorize your gift ideas for each person. Set budgets, statuses, and event dates."
        ),
        OnboardingPage(
            image: "chart.bar.fill",
            title: "Track & Analyze",
            subtitle: "Simple Statistics",
            description: "Browse by people, filter the global list, and keep a simple stats overview. It's private, structured, and handy."
        )
    ]
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? AppColors.primaryYellow : AppColors.textTertiary)
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.top, 60)
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 16) {
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage += 1
                            }
                        } else {
                            UserDefaults.standard.set(true, forKey: "OnboardingCompleted")
                            isOnboardingCompleted = true
                        }
                    }) {
                        HStack {
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                                .font(AppFonts.buttonLarge)
                                .foregroundColor(AppColors.primaryBlue)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(AppColors.primaryBlue)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(AppColors.primaryYellow)
                        .cornerRadius(28)
                    }
                    
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            UserDefaults.standard.set(true, forKey: "OnboardingCompleted")
                            isOnboardingCompleted = true
                        }
                        .font(AppFonts.bodyMedium)
                        .foregroundColor(AppColors.textSecondary)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage {
    let image: String
    let title: String
    let subtitle: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: page.image)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryYellow)
                .frame(height: 120)
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(page.title == "Organize by People" ? AppFonts.title1 : AppFonts.largeTitle)
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(page.subtitle)
                    .font(AppFonts.title3)
                    .foregroundColor(AppColors.primaryYellow)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(isOnboardingCompleted: .constant(false))
}
