import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var opacity: Double = 0.0
    var onComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            title: "Keep your makeup magic organized",
            description: "Create your personal makeup idea catalog — your space to remember every look that made you feel confident.",
            systemImage: "sparkles"
        ),
        OnboardingPage(
            title: "Save every detail",
            description: "Save your favorite color combinations, note the products you used, and write down each step to recreate them anytime.",
            systemImage: "square.and.pencil"
        ),
        OnboardingPage(
            title: "Organize and rediscover",
            description: "Mark your best looks, sort them by category — day, evening, or creative — and rediscover what truly works for you. Simple, private, and built for your beauty creativity.",
            systemImage: "heart.circle"
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
                            .fill(index == currentPage ? AppColors.primaryYellow : AppColors.primaryBlue.opacity(0.3))
                            .frame(width: 10, height: 10)
                            .scaleEffect(index == currentPage ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 40)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage += 1
                        }
                    } else {
                        onComplete()
                    }
                }) {
                    Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(AppColors.contrastText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(AppColors.primaryYellow)
                        .cornerRadius(28)
                        .shadow(color: AppColors.primaryYellow.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeIn(duration: 0.8)) {
                opacity = 1.0
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
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.systemImage)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryBlue)
                .padding(.bottom, 20)
            
            VStack(spacing: 24) {
                Text(page.title)
                    .font(.playfairDisplay(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 40)
            
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
