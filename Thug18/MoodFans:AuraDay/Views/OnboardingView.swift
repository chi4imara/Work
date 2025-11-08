import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    @State private var animateContent = false
    
    private let pages = [
        OnboardingPage(
            title: "Color Your Mood",
            subtitle: "Track Your Days",
            description: "This app turns your emotions into colors. Every day you choose one shade that reflects how you feel: joy, calm, sadness, or energy.",
            systemImage: "paintpalette.fill"
        ),
        OnboardingPage(
            title: "Your Personal",
            subtitle: "Mood Diary",
            description: "Each choice is saved in a calendar, creating a simple but powerful picture of your emotional journey. Add notes and highlight special days.",
            systemImage: "calendar"
        ),
        OnboardingPage(
            title: "Private & Offline",
            subtitle: "Always Yours",
            description: "Private, offline, and easy — it's your personal mood diary in colors. Favorites help you mark important moments, while statistics show your patterns.",
            systemImage: "lock.shield.fill"
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
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                VStack(spacing: AppTheme.Spacing.lg) {
                    HStack(spacing: AppTheme.Spacing.sm) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppTheme.Colors.accentYellow : Color.white.opacity(0.4))
                                .frame(width: 10, height: 10)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    .padding(.bottom, AppTheme.Spacing.md)
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.5)) {
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
                                .font(AppTheme.Fonts.buttonFont)
                                .foregroundColor(AppTheme.Colors.backgroundBlue)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(AppTheme.Colors.backgroundBlue)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(AppTheme.Colors.accentYellow)
                        .cornerRadius(AppTheme.CornerRadius.large)
                    }
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showOnboarding = false
                            }
                        }
                        .font(AppTheme.Fonts.callout)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .padding(.top, AppTheme.Spacing.sm)
                    }
                }
                .padding(.bottom, AppTheme.Spacing.xl)
            }
        }
        .onAppear {
            animateContent = true
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var animateIcon = false
    @State private var animateText = false
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.xl) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 120, height: 120)
                    .scaleEffect(animateIcon ? 1.0 : 0.8)
                    .opacity(animateIcon ? 1.0 : 0.6)
                
                Image(systemName: page.systemImage)
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(AppTheme.Colors.accentYellow)
                    .scaleEffect(animateIcon ? 1.0 : 0.8)
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                    animateIcon = true
                }
            }
            
            Spacer()
            
            VStack(spacing: AppTheme.Spacing.md) {
                VStack(spacing: AppTheme.Spacing.xs) {
                    Text(page.title)
                        .font(AppTheme.Fonts.title1)
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .multilineTextAlignment(.center)
                    
                    Text(page.subtitle)
                        .font(AppTheme.Fonts.title2)
                        .foregroundColor(AppTheme.Colors.accentYellow)
                        .multilineTextAlignment(.center)
                }
                .opacity(animateText ? 1.0 : 0.0)
                .offset(y: animateText ? 0 : 20)
                
                Text(page.description)
                    .font(AppTheme.Fonts.footnote)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .opacity(animateText ? 1.0 : 0.0)
                    .offset(y: animateText ? 0 : 20)
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .onAppear {
                withAnimation(.easeOut(duration: 0.8).delay(0.5)) {
                    animateText = true
                }
            }
            
            Spacer()
        }
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let description: String
    let systemImage: String
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
