import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    var onComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            title: "Capture the beauty of your daily rituals",
            description: "Everyday moments can be beautiful — the first sip of morning coffee, the soft light of a candle at night, or the simple act of choosing your favorite earrings.",
            systemImage: "cup.and.saucer.fill"
        ),
        OnboardingPage(
            title: "Your Personal Visual Journal",
            description: "This app helps you collect these moments into your own visual journal — a calm, elegant space where your daily rituals live in order and harmony.",
            systemImage: "book.fill"
        ),
        OnboardingPage(
            title: "Organize Your Beautiful Habits",
            description: "Add your habits manually: give each one a name, category, time, and short note that describes what makes it special. Group them by parts of the day — morning, afternoon, evening, or weekend.",
            systemImage: "square.grid.3x3.fill"
        ),
        OnboardingPage(
            title: "Appreciate the Little Things",
            description: "Your 'Beautiful Habits Journal' is not about tracking or improvement. It's about appreciating the little things that shape your days — the smell of perfume before leaving home, a fresh cup of tea, or the quiet ritual of tidying your desk.",
            systemImage: "heart.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            AnimatedBubblesBackground()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 20) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.accent : AppColors.accentBlue.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut, value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            onComplete()
                        }
                    }) {
                        Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                            .font(.ubuntu(size: 18, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(AppColors.accentGradient)
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
            
            Image(systemName: page.systemImage)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.accent)
                .symbolRenderingMode(.hierarchical)
                .padding(.bottom, 20)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.ubuntu(size: 28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(.ubuntu(size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let systemImage: String
}
