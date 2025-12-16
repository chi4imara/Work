import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    let onComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            icon: "wind",
            title: "Capture the scent of your city",
            description: "This app helps you notice what your city smells like — today, tomorrow, and every season."
        ),
        OnboardingPage(
            icon: "book.pages",
            title: "Build your scent diary",
            description: "Each day, you write down the scent you feel: rain, coffee, asphalt, or something entirely your own."
        ),
        OnboardingPage(
            icon: "heart",
            title: "Create living memories",
            description: "Over time, you'll build a living map of aromas — a diary of mornings, evenings, and moments that define your world. Smell connects memory and place. Capture it before it fades."
        )
    ]
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
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
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.appPrimaryYellow : Color.appTextTertiary)
                                .frame(width: 8, height: 8)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    CustomButton(
                        title: currentPage == pages.count - 1 ? "Get Started" : "Continue",
                        action: {
                            if currentPage < pages.count - 1 {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    currentPage += 1
                                }
                            } else {
                                onComplete()
                            }
                        }
                    )
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.appPrimaryYellow.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(
                        .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                
                Image(systemName: page.icon)
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(.appPrimaryYellow)
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(.appTextPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(.appTextSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    OnboardingView(onComplete: {})
}
