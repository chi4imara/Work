import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appViewModel: AppViewModel
    @State private var currentPage = 0
    
    private let onboardingPages = [
        OnboardingPage(
            title: "Start your day with focus",
            description: "Plan your day, track energy and concentration to be productive.",
            iconName: "target"
        ),
        OnboardingPage(
            title: "Small steps - big results",
            description: "Add mini-challenges and habits for physical and mental development.",
            iconName: "flame.fill"
        ),
        OnboardingPage(
            title: "Your personal space",
            description: "Achievement diary, visual progress and text tips for your motivation.",
            iconName: "star.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    ForEach(0..<onboardingPages.count, id: \.self) { index in
                        Capsule()
                            .fill(index <= currentPage ? AppColors.primaryOrange : AppColors.primaryText.opacity(0.3))
                            .frame(width: index == currentPage ? 24 : 8, height: 8)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.top, 60)
                .padding(.horizontal, 20)
                
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingPages.count, id: \.self) { index in
                        OnboardingPageView(page: onboardingPages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                VStack(spacing: 16) {
                    Button(action: {
                        if currentPage < onboardingPages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentPage += 1
                            }
                        } else {
                            appViewModel.completeOnboarding()
                        }
                    }) {
                        HStack {
                            Text(currentPage < onboardingPages.count - 1 ? "Continue" : "Get Started")
                                .font(.ubuntu(.semiBold, size: 18))
                                .foregroundColor(AppColors.primaryText)
                            
                            if currentPage < onboardingPages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(AppColors.primaryText)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: AppConstants.buttonHeight)
                        .background(AppColors.buttonGradient)
                        .cornerRadius(AppConstants.mediumCornerRadius)
                    }
                    
                    if currentPage < onboardingPages.count - 1 {
                        Button("Skip") {
                            appViewModel.completeOnboarding()
                        }
                        .font(.ubuntu(.medium, size: 16))
                        .foregroundColor(AppColors.secondaryText)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -50 && currentPage < onboardingPages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage += 1
                        }
                    } else if value.translation.width > 50 && currentPage > 0 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage -= 1
                        }
                    }
                }
        )
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let iconName: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 120, height: 120)
                
                Image(systemName: page.iconName)
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(AppColors.primaryOrange)
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.ubuntu(.bold, size: AppConstants.headerFontSize))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(.ubuntu(.regular, size: AppConstants.mediumFontSize))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    OnboardingView(appViewModel: AppViewModel())
}
