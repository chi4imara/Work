import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appState: AppStateViewModel
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    private let pages = [
        OnboardingPage(
            title: "Keep conversations clear and remembered",
            description: "This app helps you capture short notes about conversations and meetings. Write down who you talked to, the topic, and one clear outcome.",
            imageName: "person.2.fill",
            color: Color.purple
        ),
        OnboardingPage(
            title: "Simple and focused",
            description: "It's a simple way to keep track of important interactions without analysis or conclusions, so you can recall facts and context whenever you need.",
            imageName: "note.text",
            color: AppColors.secondary
        ),
        OnboardingPage(
            title: "Ready to start?",
            description: "Begin capturing your conversations and never forget important details from your meetings and discussions.",
            imageName: "checkmark.circle.fill",
            color: AppColors.success
        )
    ]
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack(spacing: AppSpacing.sm) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? AppColors.secondary : AppColors.textTertiary)
                            .frame(width: 8, height: 8)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.top, AppSpacing.lg)
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(
                            page: pages[index],
                            isAnimating: isAnimating
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                HStack {
                    if currentPage > 0 {
                        Button("Back") {
                            withAnimation {
                                currentPage -= 1
                            }
                        }
                        .font(AppFonts.button())
                        .foregroundColor(AppColors.textSecondary)
                        .frame(maxWidth: .infinity)
                        
                        Spacer()
                    }
                    
                    Button {
                        if currentPage == pages.count - 1 {
                            appState.completeOnboarding()
                        } else {
                            withAnimation {
                                currentPage += 1
                            }
                        }
                    } label: {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(AppFonts.button())
                            .foregroundColor(AppColors.textPrimary)
                            .padding(.horizontal, AppSpacing.lg)
                            .padding(.vertical, AppSpacing.md)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: AppCornerRadius.md)
                                    .fill(AppColors.secondary)
                            )
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, AppSpacing.xl)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                isAnimating = true
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let isAnimating: Bool
    
    var body: some View {
        VStack(spacing: AppSpacing.xl) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(page.color)
                .scaleEffect(isAnimating ? 1.0 : 0.5)
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.8).delay(0.2), value: isAnimating)
            
            VStack(spacing: AppSpacing.lg) {
                Text(page.title)
                    .font(AppFonts.title(28))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .offset(y: isAnimating ? 0 : 50)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: isAnimating)
                
                Text(page.description)
                    .font(AppFonts.body(18))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .offset(y: isAnimating ? 0 : 30)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: isAnimating)
            }
            .padding(.horizontal, AppSpacing.lg)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(appState: AppStateViewModel())
}
