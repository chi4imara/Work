import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    let onComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            image: "quote.bubble.fill",
            title: "Save Quotes. Capture Thoughts. Keep Your Inspiration.",
            description: "This app is your personal archive of ideas and favorite quotes. Here you can quickly write down a thought that came to mind, store inspiring phrases, or organize work notes."
        ),
        OnboardingPage(
            image: "list.bullet.rectangle",
            title: "Organize Your Ideas",
            description: "On the main screen you'll find a clear feed of everything you've saved — each entry has a title, type, category, and a note. Open any card to see full details, edit it, or move it to the archive when it's no longer relevant."
        ),
        OnboardingPage(
            image: "archivebox.fill",
            title: "Never Lose Your Thoughts",
            description: "A separate archive section keeps all your past ideas safe, so nothing is lost — you can always return to them later. Categories help you group similar notes, whether they're about creativity, hobbies, or professional projects."
        ),
        OnboardingPage(
            image: "magnifyingglass",
            title: "Find What You Need",
            description: "Use the search and filters to instantly find the right idea, even if you only remember one word. No accounts, no unnecessary features — just a simple, private, and structured space for your thoughts."
        )
    ]
    
    var body: some View {
        ZStack {
            DesignSystem.Gradients.backgroundGradient
                .ignoresSafeArea()
            
            BlueWebPattern()
                .opacity(0.1)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(DesignSystem.Animation.standard, value: currentPage)
                
                VStack(spacing: DesignSystem.Spacing.lg) {
                    HStack(spacing: DesignSystem.Spacing.sm) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? DesignSystem.Colors.primaryBlue : DesignSystem.Colors.lightBlue)
                                .frame(width: 10, height: 10)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(DesignSystem.Animation.quick, value: currentPage)
                        }
                    }
                    
                    HStack(spacing: DesignSystem.Spacing.md) {
                        if currentPage > 0 {
                            Button("Back") {
                                withAnimation(DesignSystem.Animation.standard) {
                                    currentPage -= 1
                                }
                            }
                            .secondaryButtonStyle()
                        }
                        
                        Spacer()
                        
                        Button(currentPage == pages.count - 1 ? "Get Started" : "Continue") {
                            if currentPage == pages.count - 1 {
                                onComplete()
                            } else {
                                withAnimation(DesignSystem.Animation.standard) {
                                    currentPage += 1
                                }
                            }
                        }
                        .primaryButtonStyle()
                    }
                    
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            onComplete()
                        }
                        .font(FontManager.poppinsRegular(size: 14))
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.lg)
                .padding(.bottom, DesignSystem.Spacing.xl)
            }
        }
    }
}

struct OnboardingPage {
    let image: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.xl) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(DesignSystem.Colors.lightBlue.opacity(0.2))
                    .frame(width: 200, height: 200)
                
                Image(systemName: page.image)
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(DesignSystem.Colors.primaryBlue)
            }
            
            VStack(spacing: DesignSystem.Spacing.lg) {
                Text(page.title)
                    .font(FontManager.poppinsBold(size: 24))
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(FontManager.poppinsRegular(size: 16))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .lineSpacing(4)
            }
            .padding(.horizontal, DesignSystem.Spacing.lg)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
