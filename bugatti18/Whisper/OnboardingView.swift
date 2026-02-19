import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appViewModel: AppViewModel
    @State private var currentPage = 0
    @State private var offset: CGFloat = 0
    
    private let pages = OnboardingPage.allPages
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack(spacing: Theme.Spacing.sm) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Capsule()
                            .fill(index <= currentPage ? Theme.Colors.primary : Theme.Colors.primary.opacity(0.3))
                            .frame(width: index == currentPage ? 30 : 10, height: 6)
                            .animation(Theme.Animation.medium, value: currentPage)
                    }
                }
                .padding(.top, Theme.Spacing.xl)
                .padding(.horizontal, Theme.Spacing.lg)
                
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        OnboardingPageView(page: page)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(Theme.Animation.medium, value: currentPage)
                
                VStack(spacing: Theme.Spacing.lg) {
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(Theme.Animation.medium) {
                                currentPage += 1
                            }
                        } else {
                            appViewModel.completeOnboarding()
                        }
                    }) {
                        HStack {
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                                .font(Theme.Fonts.playfairSemiBold(size: 18))
                                .foregroundColor(.white)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Theme.Spacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.lg)
                                .fill(
                                    LinearGradient(
                                        colors: [Theme.Colors.primary, Theme.Colors.accent],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                    }
                    .padding(.horizontal, Theme.Spacing.lg)
                    
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            appViewModel.completeOnboarding()
                        }
                        .font(Theme.Fonts.playfairMedium(size: 16))
                        .foregroundColor(Theme.Colors.textSecondary)
                    }
                }
                .padding(.bottom, Theme.Spacing.xl)
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var isAnimated = false
    
    var body: some View {
        VStack(spacing: 15) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                page.accentColor.opacity(0.2),
                                page.accentColor.opacity(0.05)
                            ],
                            center: .center,
                            startRadius: 50,
                            endRadius: 150
                        )
                    )
                    .frame(width: 250, height: 250)
                    .scaleEffect(isAnimated ? 1.1 : 0.9)
                    .animation(
                        Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                        value: isAnimated
                    )
                
                Image(systemName: page.icon)
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(page.accentColor)
                    .scaleEffect(isAnimated ? 1.2 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                        value: isAnimated
                    )
            }
            
            Spacer()
            
            VStack(spacing: Theme.Spacing.lg) {
                Text(page.title)
                    .font(Theme.Fonts.playfairBold(size: 24))
                    .foregroundColor(Theme.Colors.text)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.Spacing.lg)
                
                Text(page.description)
                    .font(Theme.Fonts.playfairRegular(size: 18))
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, Theme.Spacing.lg)
            }
            
            Spacer()
        }
        .onAppear {
            isAnimated = true
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let icon: String
    let accentColor: Color
    
    static let allPages = [
        OnboardingPage(
            title: "Start your day with gratitude",
            description: "Record emotions, note joys and create positive habits every day.",
            icon: "sun.max.fill",
            accentColor: Theme.Colors.secondary
        ),
        OnboardingPage(
            title: "Small steps - big changes",
            description: "Create mini-challenges and habits to feel progress and joy.",
            icon: "arrow.up.circle.fill",
            accentColor: Theme.Colors.accent
        ),
        OnboardingPage(
            title: "Let's get started",
            description: "Daily tasks, visual rewards and micro-support are waiting for you.",
            icon: "heart.fill",
            accentColor: Theme.Colors.primary
        )
    ]
}

#Preview {
    OnboardingView(appViewModel: AppViewModel())
}
