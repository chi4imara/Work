import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    private let onboardingPages = [
        OnboardingPage(
            title: "Save Every Gift Idea",
            description: "Keep all your gift ideas in one simple place. Add presents for friends and family, note who they are for, group them into categories.",
            imageName: "gift"
        ),
        OnboardingPage(
            title: "Stay Organized",
            description: "Mark whether gifts are already bought or still in plans. Each entry stays neatly organized, so when the holiday or birthday comes, you know exactly what to choose.",
            imageName: "list.bullet.clipboard"
        ),
        OnboardingPage(
            title: "Never Forget Again",
            description: "Clear, structured, and easy to use — your personal catalog of thoughtful gifts always at hand.",
            imageName: "heart"
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingPages.count, id: \.self) { index in
                        OnboardingPageView(page: onboardingPages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 30) {
                    HStack(spacing: 12) {
                        ForEach(0..<onboardingPages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.primaryText : AppColors.primaryText.opacity(0.3))
                                .frame(width: 10, height: 10)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < onboardingPages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentPage += 1
                            }
                        } else {
                            completeOnboarding()
                        }
                    }) {
                        Text(currentPage == onboardingPages.count - 1 ? "Get Started" : "Continue")
                            .font(.appHeadline(18))
                            .foregroundColor(AppColors.primaryBlue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppColors.primaryText)
                            .cornerRadius(25)
                            .scaleEffect(isAnimating ? 1.05 : 1.0)
                    }
                    .padding(.horizontal, 40)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                            isAnimating = true
                        }
                    }
                }
                .padding(.bottom, 50)
            }
        }
    }
    
    private func completeOnboarding() {
        withAnimation(.easeInOut(duration: 0.5)) {
            hasCompletedOnboarding = true
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var imageScale: CGFloat = 0.8
    @State private var textOpacity: Double = 0
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryText)
                .scaleEffect(imageScale)
                .onAppear {
                    withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                        imageScale = 1.0
                    }
                }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.appTitle(32))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .opacity(textOpacity)
                
                Text(page.description)
                    .font(.appBody(16))
                    .foregroundColor(AppColors.primaryText.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .opacity(textOpacity)
            }
            .padding(.horizontal, 30)
            .onAppear {
                withAnimation(.easeOut(duration: 0.8).delay(0.5)) {
                    textOpacity = 1.0
                }
            }
            
            Spacer()
        }
    }
}
