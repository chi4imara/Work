import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var showOnboarding: Bool
    
    private let pages = OnboardingPage.allPages
    
    var body: some View {
        ZStack {
            AnimatedBackgroundView()
            
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
                            .fill(currentPage == index ? Color.primaryYellow : Color.primaryWhite.opacity(0.4))
                            .frame(width: 12, height: 12)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 40)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        showOnboarding = false
                    }
                }) {
                    Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                        .font(.playfairHeading(18))
                        .foregroundColor(.buttonText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.buttonPrimary)
                        .cornerRadius(28)
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 32)
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
            
            ZStack {
                Circle()
                    .fill(Color.primaryWhite.opacity(0.15))
                    .frame(width: 160, height: 160)
                
                Image(systemName: page.iconName)
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(.primaryYellow)
            }
            
            VStack(spacing: 24) {
                Text(page.title)
                    .font(.playfairTitleLarge(32))
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(.playfairBody(18))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let iconName: String
    
    static let allPages = [
        OnboardingPage(
            title: "Preserve the Story",
            description: "Keep the memories of your old belongings alive. From family heirlooms to everyday items with meaning.",
            iconName: "heart.circle"
        ),
        OnboardingPage(
            title: "Personal Catalog",
            description: "Build your own private archive. Each entry holds a name, story, and details that matter to you.",
            iconName: "book.circle"
        ),
        OnboardingPage(
            title: "Your History",
            description: "Over time, create a collection that makes it easy to revisit memories and organize them. One item at a time.",
            iconName: "clock.circle"
        )
    ]
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
