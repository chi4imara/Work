import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    var onComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            title: "End Your Day with Calm",
            description: "This app helps you close the day gently — one calm phrase and one simple evening ritual at a time.",
            systemImage: "moon.stars.fill"
        ),
        OnboardingPage(
            title: "Evening Ritual",
            description: "Each night, you'll see a gentle reminder to turn off the light, a relaxing message, and a short 3-step practice called 'Let Go of the Day'.",
            systemImage: "lightbulb.fill"
        ),
        OnboardingPage(
            title: "Moment of Peace",
            description: "It's a moment to pause, breathe, and release everything that can wait until tomorrow. No tasks, no tracking — just a small space of calm before night.",
            systemImage: "leaf.fill"
        )
    ]
    
    var body: some View {
        BackgroundContainer {
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                HStack(spacing: 12) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? ColorTheme.primaryYellow : ColorTheme.primaryBlue.opacity(0.3))
                            .frame(width: 10, height: 10)
                            .scaleEffect(index == currentPage ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 40)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    } else {
                        onComplete()
                    }
                }) {
                    Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(ColorTheme.backgroundWhite)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        colors: [ColorTheme.primaryYellow, ColorTheme.warmOrange],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                        .shadow(color: ColorTheme.primaryYellow.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let systemImage: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.systemImage)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorTheme.primaryBlue)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
            
            VStack(spacing: 24) {
                Text(page.title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 32)
    }
}

#Preview {
    OnboardingView(onComplete: {})
}
