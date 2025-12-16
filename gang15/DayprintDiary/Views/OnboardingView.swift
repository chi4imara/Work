import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    let onComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            title: "Remember One Thing Each Day",
            description: "This app helps you keep one small memory from every day. Each evening, you'll see a simple question — 'What will you remember today?' — and you can write a short note, just a few words or a sentence.",
            systemImage: "heart.fill"
        ),
        OnboardingPage(
            title: "Build Your Memory Archive",
            description: "Over time, these moments form your quiet archive of days — ordinary details, warm moments, small thoughts. You don't have to write perfectly — just capture something true about your day.",
            systemImage: "book.fill"
        ),
        OnboardingPage(
            title: "One Line a Day",
            description: "One line a day, one memory at a time. Start your journey of mindful remembering today.",
            systemImage: "pencil.and.outline"
        )
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .fill(AppTheme.Colors.orb1)
                        .frame(width: 40 + CGFloat(index * 10))
                        .position(
                            x: geometry.size.width * (0.2 + Double(index) * 0.2),
                            y: geometry.size.height * (0.1 + Double(index) * 0.2)
                        )
                        .animation(
                            Animation.easeInOut(duration: 4 + Double(index))
                                .repeatForever(autoreverses: true),
                            value: currentPage
                        )
                }
                
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
                                    .fill(index == currentPage ? AppTheme.Colors.primaryText : AppTheme.Colors.secondaryText)
                                    .frame(width: 8, height: 8)
                                    .scaleEffect(index == currentPage ? 1.2 : 1.0)
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
                                onComplete()
                            }
                        }) {
                            HStack {
                                Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                                    .font(AppTheme.Typography.headline)
                                    .foregroundColor(AppTheme.Colors.primaryText)
                                
                                if currentPage < pages.count - 1 {
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(AppTheme.Colors.primaryText)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppTheme.Spacing.md)
                            .background(AppTheme.Colors.primaryPurple)
                            .cornerRadius(AppTheme.CornerRadius.md)
                        }
                        .padding(.horizontal, AppTheme.Spacing.lg)
                        
                        if currentPage < pages.count - 1 {
                            Button("Skip") {
                                onComplete()
                            }
                            .font(AppTheme.Typography.callout)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                        }
                    }
                    .padding(.bottom, AppTheme.Spacing.xl)
                }
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
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: page.systemImage)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppTheme.Colors.primaryText)
                .padding(.bottom, AppTheme.Spacing.lg)
            
            Text(page.title)
                .font(AppTheme.Typography.largeTitle)
                .foregroundColor(AppTheme.Colors.primaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppTheme.Spacing.lg)
            
            Text(page.description)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, AppTheme.Spacing.xl)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
