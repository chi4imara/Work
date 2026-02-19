import SwiftUI

struct OnboardingView: View {
    let onComplete: () -> Void
    @State private var currentPage = 0
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Accessorize your life",
            description: "Discover the perfect accessories for any outfit, try virtual looks, save your favorites, and create stylish combinations effortlessly.",
            icon: "sparkles"
        ),
        OnboardingPage(
            title: "Virtual try-on",
            description: "See how bags, jewelry, belts and hats look on you before you buy. No more guessing – style with confidence.",
            icon: "camera.viewfinder"
        ),
        OnboardingPage(
            title: "Your style, your way",
            description: "Build your personal collection, get stylist recommendations and track your favorite looks. All in one place.",
            icon: "heart.circle"
        )
    ]
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        OnboardingPageView(page: page)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: currentPage)
                
                pageIndicator
                    .padding(.top, 24)
                
                actionButton
                    .padding(.horizontal, AppConstants.cardPadding)
                    .padding(.top, 32)
                    .padding(.bottom, 50)
            }
        }
        .ignoresSafeArea()
    }
    
    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<pages.count, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? AppColors.primaryYellow : Color.gray)
                    .frame(width: index == currentPage ? 10 : 8, height: index == currentPage ? 10 : 8)
                    .animation(.easeInOut(duration: 0.2), value: currentPage)
            }
        }
    }
    
    private var actionButton: some View {
        Button(action: {
            if currentPage < pages.count - 1 {
                withAnimation {
                    currentPage += 1
                }
            } else {
                onComplete()
            }
        }) {
            Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(AppColors.backgroundWhite)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppColors.buttonGradient)
                .cornerRadius(AppConstants.cornerRadius)
                .shadow(color: AppColors.primaryYellow.opacity(0.3), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let icon: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.primaryYellow.opacity(0.2))
                    .frame(width: 160, height: 160)
                
                Circle()
                    .fill(AppColors.buttonGradient)
                    .frame(width: 120, height: 120)
                    .shadow(color: AppColors.primaryYellow.opacity(0.4), radius: 12, x: 0, y: 6)
                
                Image(systemName: page.icon)
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(AppColors.backgroundWhite)
            }
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.playfairDisplay(28, weight: .bold))
                    .foregroundColor(AppColors.textBlue)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(AppColors.darkGray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 24)
            }
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, AppConstants.cardPadding)
    }
}

#Preview {
    OnboardingView(onComplete: {})
}
