import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPageView(
                        icon: "heart.fill",
                        title: "Build your personal brand list.",
                        description: "Create your own collection of fashion and beauty brands, rate them, and keep notes on what you enjoy. Organize your tastes in one simple place and stay inspired when choosing clothes or cosmetics from the brands you trust.",
                        pageIndex: 0
                    )
                    .tag(0)
                    
                    OnboardingPageView(
                        icon: "star.fill",
                        title: "Rate and organize.",
                        description: "Give your favorite brands ratings from 1 to 5 stars. Categorize them by type - clothing, cosmetics, accessories, perfume, or create your own custom categories. Keep track of what you love most.",
                        pageIndex: 1
                    )
                    .tag(1)
                    
                    OnboardingPageView(
                        icon: "magnifyingglass",
                        title: "Find what you need.",
                        description: "Search through your collection instantly. Filter by categories to quickly find the brands you're looking for. Your personal brand catalog is always at your fingertips.",
                        pageIndex: 2
                    )
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack(spacing: 12) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? AppColors.primaryYellow : AppColors.primaryWhite.opacity(0.4))
                            .frame(width: 10, height: 10)
                    }
                }
                .padding(.bottom, 30)
                
                Button(action: {
                    if currentPage < 2 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        showOnboarding = true
                        UserDefaults.standard.set(true, forKey: "HasSeenOnboarding")
                    }
                }) {
                    Text(currentPage < 2 ? "Next" : "Get Started")
                        .font(.bauhaus(18, weight: .bold))
                        .foregroundColor(AppColors.buttonText)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColors.buttonBackground)
                        .cornerRadius(25)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)
                }
            }
        }
    }
}

struct OnboardingPageView: View {
    let icon: String
    let title: String
    let description: String
    let pageIndex: Int
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.primaryWhite.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: icon)
                    .font(.system(size: 50))
                    .foregroundColor(AppColors.primaryYellow)
            }
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.bauhaus(32, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Text(description)
                    .font(.bauhaus(16, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
            }
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
