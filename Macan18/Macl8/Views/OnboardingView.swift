import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var isOnboardingCompleted: Bool
    
    private let pages = [
        OnboardingPage(
            title: "Collect the words that define your style.",
            description: "Some phrases stay with you — a line from a film, a sentence in a book, a quote that captures who you are.",
            imageName: "quote.bubble"
        ),
        OnboardingPage(
            title: "Your private gallery of beautiful thoughts",
            description: "This app is your private gallery of beautiful thoughts and timeless words about style, beauty, and life.",
            imageName: "heart.text.square"
        ),
        OnboardingPage(
            title: "Organize your collection effortlessly",
            description: "Save every quote that resonates with you. Add its author, source, and theme — whether it's about elegance, dreams, or confidence.",
            imageName: "folder.badge.plus"
        ),
        OnboardingPage(
            title: "Simple, aesthetic, and private",
            description: "This app turns your love for words into a beautifully organized notebook of style and thought — one elegant quote at a time.",
            imageName: "book.closed"
        )
    ]
    
    var body: some View {
        ZStack {
            AppTheme.Gradients.primaryBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: AppTheme.Spacing.lg) {
                    HStack(spacing: AppTheme.Spacing.sm) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppTheme.Colors.accent : AppTheme.Colors.accent.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    .padding(.bottom, AppTheme.Spacing.md)
                    
                    HStack(spacing: AppTheme.Spacing.md) {
                        if currentPage > 0 {
                            Button {
                                withAnimation {
                                    currentPage -= 1
                                }
                            } label: {
                                Text("Back")
                                    .secondaryButton()
                            }
                            
                            Spacer()
                        }
                        
                        Button {
                            if currentPage == pages.count - 1 {
                                isOnboardingCompleted = true
                            } else {
                                withAnimation {
                                    currentPage += 1
                                }
                            }
                        } label: {
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Next")
                                .primaryButton()
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.lg)
                }
                .padding(.bottom, AppTheme.Spacing.xl)
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.xl) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppTheme.Colors.accent)
                .padding(.bottom, AppTheme.Spacing.lg)
            
            Text(page.title)
                .font(.playfairDisplay(AppTheme.Typography.title1, weight: .bold))
                .foregroundColor(AppTheme.Colors.primaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppTheme.Spacing.lg)
            
            Text(page.description)
                .font(.playfairDisplay(AppTheme.Typography.body, weight: .regular))
                .foregroundColor(AppTheme.Colors.secondaryText)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, AppTheme.Spacing.xl)
            
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
    OnboardingView(isOnboardingCompleted: .constant(false))
}
