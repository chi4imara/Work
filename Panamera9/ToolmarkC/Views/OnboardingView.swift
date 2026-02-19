import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            title: "Organize your personal tool inventory.",
            description: "Store clear, structured information about all your tools. Record sizes, types, models, storage locations, and personal notes.",
            imageName: "wrench.and.screwdriver"
        ),
        OnboardingPage(
            title: "Quick Browse & Search",
            description: "Quickly browse categories or storage places and keep your entire tool collection neatly organized and easy to access anytime.",
            imageName: "magnifyingglass"
        ),
        OnboardingPage(
            title: "Never Lose Track",
            description: "Know exactly where each tool is stored and what specifications it has. Perfect for professionals and hobbyists alike.",
            imageName: "location"
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
                
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? ColorTheme.accentOrange : ColorTheme.mutedText)
                            .frame(width: 8, height: 8)
                            .scaleEffect(index == currentPage ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.top, 60)
                .padding(.bottom, 40)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    } else {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showOnboarding = false
                        }
                    }
                }) {
                    HStack {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(FontManager.body(.medium))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        if currentPage < pages.count - 1 {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(ColorTheme.primaryText)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(ColorTheme.accentGradient)
                    .cornerRadius(25)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
                
                if currentPage < pages.count - 1 {
                    Button("Skip") {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showOnboarding = false
                        }
                    }
                    .font(FontManager.caption(.light))
                    .foregroundColor(ColorTheme.mutedText)
                    .padding(.bottom, 30)
                }
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(ColorTheme.cardGradient)
                    .frame(width: 120, height: 120)
                
                Image(systemName: page.imageName)
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(ColorTheme.accentOrange)
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(FontManager.title(.bold))
                    .foregroundColor(ColorTheme.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Text(page.description)
                    .font(FontManager.body(.regular))
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
    let imageName: String
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
