import SwiftUI

struct OnboardingView: View {
    @ObservedObject var store: PerfumeStore
    @State private var currentPage = 0
    
    let pages = [
        OnboardingPage(
            title: "Build your personal perfume library.",
            description: "Keep track of every scent you own — from elegant classics to everyday favorites. Add notes, season, and mood to each perfume, and mark how often you wear it.",
            systemImage: "sparkles"
        ),
        OnboardingPage(
            title: "Discover your scent habits",
            description: "Over time, you'll see which fragrances define your mood and which ones you reach for most. What you prefer in winter, what brightens your mornings, and what feels perfect for a night out.",
            systemImage: "chart.bar.fill"
        ),
        OnboardingPage(
            title: "Record your favorite combinations",
            description: "Simple, elegant, and made for those who love fragrances — your entire perfume wardrobe, beautifully organized in one place.",
            systemImage: "heart.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            AppGradients.backgroundGradient
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
                                .fill(currentPage == index ? Color.primaryYellow : Color.white.opacity(0.3))
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
                            store.completeOnboarding()
                        }
                    }) {
                        Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(.primaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(AppGradients.yellowGradient)
                            .cornerRadius(25)
                    }
                    .padding(.horizontal, 40)
                }
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
                .foregroundColor(.primaryYellow)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Text(page.description)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}
