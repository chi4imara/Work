import SwiftUI

struct OnboardingView: View {
    let onComplete: () -> Void
    
    @State private var currentPage = 0
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "fork.knife",
            title: "Cook healthy, eat happy",
            description: "Discover recipes tailored to your goals and cooking level."
        ),
        OnboardingPage(
            icon: "calendar",
            title: "Plan your meals",
            description: "Create weekly menus, track your nutrition, and never miss a meal."
        ),
        OnboardingPage(
            icon: "heart.fill",
            title: "Enjoy every day",
            description: "Enjoy healthy and delicious food every day with personalized recommendations."
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GridPattern()
                .opacity(0.2)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        OnboardingPageView(page: page)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: currentPage)
                
                VStack(spacing: 24) {
                    PageIndicator(currentPage: currentPage, numberOfPages: pages.count)
                    
                    if currentPage == pages.count - 1 {
                        Button(action: onComplete) {
                            Text("Get Started")
                                .font(AppFonts.button(18))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                                        .fill(AppColors.primaryYellow)
                                )
                        }
                        .padding(.horizontal, 24)
                    } else {
                        HStack(spacing: 16) {
                            Button(action: { withAnimation { currentPage += 1 } }) {
                                Text("Next")
                                    .font(AppFonts.button(18))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                                            .fill(AppColors.primaryYellow)
                                    )
                            }
                            
                            Button(action: onComplete) {
                                Text("Skip")
                                    .font(AppFonts.button(16))
                                    .foregroundColor(AppColors.textSecondary)
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                }
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.primaryYellow.opacity(0.2))
                    .frame(width: 140, height: 140)
                
                Circle()
                    .fill(AppColors.cardBackground)
                    .frame(width: 120, height: 120)
                    .overlay(
                        Circle()
                            .stroke(AppColors.primaryYellow, lineWidth: 3)
                    )
                
                Image(systemName: page.icon)
                    .font(.system(size: 50))
                    .foregroundColor(AppColors.primaryYellow)
            }
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(AppFonts.title(26))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                Text(page.description)
                    .font(AppFonts.body(17))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            Spacer()
        }
    }
}

struct PageIndicator: View {
    let currentPage: Int
    let numberOfPages: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<numberOfPages, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage ? AppColors.primaryYellow : AppColors.cardBorder)
                    .frame(width: index == currentPage ? 24 : 8, height: 8)
                    .animation(.easeInOut(duration: 0.2), value: currentPage)
            }
        }
    }
}

#Preview {
    OnboardingView(onComplete: {})
}
