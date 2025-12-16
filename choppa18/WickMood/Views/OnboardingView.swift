import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var isOnboardingComplete: Bool
    
    private let pages = [
        OnboardingPage(
            title: "Collect your favorite scents",
            description: "Build your personal catalog of home fragrances. Save your favorite candles, brands, and scents — from warm winter notes to refreshing summer blends.",
            imageName: "flame.fill",
            color: AppColors.primaryPurple
        ),
        OnboardingPage(
            title: "Organize by mood & season",
            description: "Mark the ones you love, describe how they make you feel, and sort them by mood or season.",
            imageName: "heart.fill",
            color: AppColors.accentPink
        ),
        OnboardingPage(
            title: "Your unique atmosphere",
            description: "Your home's unique atmosphere — captured in one app. Start building your scent collection today.",
            imageName: "house.fill",
            color: AppColors.accentGreen
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
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
                
                HStack(spacing: 12) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? AppColors.primaryPurple : AppColors.textLight)
                            .frame(width: currentPage == index ? 12 : 8, height: currentPage == index ? 12 : 8)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.vertical, 30)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage += 1
                        }
                    } else {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isOnboardingComplete = true
                        }
                    }
                }) {
                    HStack {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(.playfairDisplay(size: 18, weight: .semibold))
                            .foregroundColor(AppColors.buttonText)
                        
                        if currentPage < pages.count - 1 {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.buttonText)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(AppColors.buttonPrimary)
                            .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
                    )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
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
    @State private var isAnimated = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.2))
                    .frame(width: 150, height: 150)
                    .scaleEffect(isAnimated ? 1.0 : 0.8)
                
                Image(systemName: page.imageName)
                    .font(.system(size: 60, weight: .medium))
                    .foregroundColor(page.color)
                    .scaleEffect(isAnimated ? 1.0 : 0.7)
            }
            .animation(.easeOut(duration: 0.8).delay(0.2), value: isAnimated)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.playfairDisplay(size: 25, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimated ? 1.0 : 0.0)
                    .offset(y: isAnimated ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: isAnimated)
                
                Text(page.description)
                    .font(.playfairDisplay(size: 16, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                    .opacity(isAnimated ? 1.0 : 0.0)
                    .offset(y: isAnimated ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: isAnimated)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .onAppear {
            isAnimated = true
        }
        .onDisappear {
            isAnimated = false
        }
    }
}

#Preview {
    OnboardingView(isOnboardingComplete: .constant(false))
}
