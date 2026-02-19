import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    let onComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            image: "heart.circle.fill",
            title: "Track what you want",
            description: "Capture your real desires and refusals, even when they feel inconsistent or hard to explain."
        ),
        OnboardingPage(
            image: "list.bullet.circle.fill",
            title: "Stay organized",
            description: "Add short entries, mark them as wants or no-wants, and see the full picture of your choices over time."
        ),
        OnboardingPage(
            image: "chart.bar.fill",
            title: "Navigate decisions clearly",
            description: "It's a simple way to stay honest with yourself and navigate decisions more clearly."
        )
    ]
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? AppColors.primaryText : AppColors.primaryText.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.top, 60)
                .padding(.bottom, 40)
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 20) {
                    if currentPage < pages.count - 1 {
                        Button(action: nextPage) {
                            HStack {
                                Text("Continue")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(AppColors.buttonText)
                                
                                Image(systemName: "arrow.right")
                                    .font(.title3)
                                    .foregroundColor(AppColors.buttonText)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppColors.buttonBackground)
                            .cornerRadius(12)
                        }
                        
                        Button(action: onComplete) {
                            Text("Skip")
                                .font(.ubuntu(16))
                                .foregroundColor(AppColors.secondaryText)
                        }
                    } else {
                        Button(action: onComplete) {
                            HStack {
                                Text("Get Started")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(AppColors.buttonText)
                                
                                Image(systemName: "checkmark")
                                    .font(.title3)
                                    .foregroundColor(AppColors.buttonText)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppColors.buttonBackground)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
    }
    
    private func nextPage() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentPage += 1
        }
    }
}

struct OnboardingPage {
    let image: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.image)
                .font(.system(size: 100))
                .foregroundColor(AppColors.primaryText)
                .shadow(color: AppColors.primaryPurple.opacity(0.3), radius: 10, x: 0, y: 5)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.ubuntu(18))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
    }
}
