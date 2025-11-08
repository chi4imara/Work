import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var isOnboardingComplete: Bool
    
    private let pages = [
        OnboardingPage(
            title: "Capture your journeys. Dream of new ones.",
            description: "Every trip is more than just a destination — it's the story you take with you. This app helps you create a personal travel diary: write down the places you've been, record your impressions, add details about what you loved most, and keep a clear overview of your journeys.",
            systemImage: "map.fill"
        ),
        OnboardingPage(
            title: "Plan your future adventures",
            description: "But travel isn't only about the past — it's about what lies ahead. That's why you can also create a wishlist of destinations you dream of visiting. Mark countries, cities, or even small towns, and keep them ready for your next adventure.",
            systemImage: "heart.fill"
        ),
        OnboardingPage(
            title: "Stay organized with ease",
            description: "With a simple calendar, you can revisit old trips by date and plan future ones with ease. Notes and memories stay structured, so you'll never forget when you were in Paris or which café in Rome you loved the most. No complex tools, no reminders — just your own space to store memories and dreams, step by step.",
            systemImage: "calendar"
        )
    ]
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                VStack(spacing: 30) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? ColorTheme.primaryText : ColorTheme.borderColor)
                                .frame(width: 8, height: 8)
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
                            .font(FontManager.subheadline)
                            .foregroundColor(ColorTheme.background)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(ColorTheme.primaryText)
                            .cornerRadius(12)
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
            
            Image(systemName: page.systemImage)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(FontManager.title)
                    .foregroundColor(ColorTheme.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Text(page.description)
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let systemImage: String
}

#Preview {
    OnboardingView(isOnboardingComplete: .constant(false))
}

