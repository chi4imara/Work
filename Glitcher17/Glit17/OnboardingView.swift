import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    @State private var animateContent = false
    
    let pages = [
        OnboardingPage(
            title: "Plan your beauty routines effortlessly.",
            description: "Create a clear schedule for all your beauty rituals. Add tasks for skin, hair, nails, and more, set their frequency, and check them off when finished.",
            systemImage: "calendar.badge.plus"
        ),
        OnboardingPage(
            title: "Build structured routines",
            description: "Build a structured routine that stays easy to follow and always organized, so every part of your beauty care fits perfectly into your day.",
            systemImage: "checkmark.circle.fill"
        ),
        OnboardingPage(
            title: "Track your progress",
            description: "Keep a detailed history of all your completed procedures. Monitor your consistency and see how your beauty routine evolves over time.",
            systemImage: "chart.line.uptrend.xyaxis"
        ),
        OnboardingPage(
            title: "Organize by categories",
            description: "Group your beauty procedures by categories like skin, hair, nails, and more. Easily find and manage all your routines in one place.",
            systemImage: "square.grid.2x2"
        )
    ]
    
    var body: some View {
        ZStack {
            ColorManager.mainGradient
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
                
                VStack(spacing: 30) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? ColorManager.accentYellow : ColorManager.textWhite.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut, value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage += 1
                            }
                        } else {
                            hasCompletedOnboarding = true
                        }
                    }) {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(FontManager.ubuntu(18, weight: .medium))
                            .foregroundColor(ColorManager.primaryPurple)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(ColorManager.buttonGradient)
                            .cornerRadius(28)
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6)) {
                animateContent = true
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
    @State private var animateIcon = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.systemImage)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorManager.accentYellow)
                .scaleEffect(animateIcon ? 1.0 : 0.8)
                .opacity(animateIcon ? 1.0 : 0.6)
                .animation(.easeInOut(duration: 0.8), value: animateIcon)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(FontManager.ubuntu(28, weight: .bold))
                    .foregroundColor(ColorManager.textWhite)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(FontManager.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6).delay(0.2)) {
                animateIcon = true
            }
        }
    }
}

#Preview {
    OnboardingView(hasCompletedOnboarding: .constant(false))
}
