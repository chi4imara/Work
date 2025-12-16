import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appState: AppState
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    let pages = [
        OnboardingPage(
            title: "Create your perfect scent harmony.",
            description: "Build your personal catalog of scent combinations — perfumes, candles, and everything that defines your atmosphere.",
            imageName: "heart.circle.fill",
            color: AppColors.purpleGradientStart
        ),
        OnboardingPage(
            title: "Save your favorite pairings",
            description: "Save your favorite pairings, explore new ones, and rediscover aromas that blend beautifully together.",
            imageName: "bookmark.circle.fill",
            color: AppColors.blueText
        ),
        OnboardingPage(
            title: "Simple, elegant design",
            description: "Simple, elegant, and designed for those who find art in fragrance.",
            imageName: "sparkles",
            color: AppColors.yellowAccent
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index], isAnimating: isAnimating)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 30) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.purpleGradientStart : AppColors.lightGray)
                                .frame(width: 10, height: 10)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.spring(), value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.spring()) {
                                currentPage += 1
                            }
                        } else {
                            appState.completeOnboarding()
                        }
                    }) {
                        HStack {
                            Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                                .font(AppFonts.headline)
                                .foregroundColor(.white)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(AppColors.buttonGradient)
                        .cornerRadius(28)
                        .shadow(color: AppColors.purpleGradientStart.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 40)
                    
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            appState.completeOnboarding()
                        }
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.darkGray)
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: 0.8)) {
                isAnimating = true
            }
        }
        .onChange(of: currentPage) { _ in
            isAnimating = false
            withAnimation(.easeIn(duration: 0.5).delay(0.1)) {
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
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.2))
                    .frame(width: 130, height: 130)
                    .scaleEffect(isAnimating ? 1.0 : 0.8)
                
                Image(systemName: page.imageName)
                    .font(.system(size: 60, weight: .medium))
                    .foregroundColor(page.color)
                    .scaleEffect(isAnimating ? 1.0 : 0.6)
            }
            .animation(.spring(response: 0.8, dampingFraction: 0.6), value: isAnimating)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(AppFonts.title)
                    .foregroundColor(AppColors.darkGray)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)
                
                Text(page.description)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.darkGray.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)
            }
            .padding(.horizontal, 40)
            .animation(.easeOut(duration: 0.6).delay(0.3), value: isAnimating)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(appState: AppState())
}
