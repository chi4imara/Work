import SwiftUI

struct OnboardingView: View {
    @Binding var isShowingOnboarding: Bool
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            title: "Build healthy habits effortlessly",
            description: "Track your daily tasks, develop new habits, and maintain balance in your lifestyle with personalized coaching.",
            imageName: "heart.circle.fill",
            color: AppColors.primaryBlue
        ),
        OnboardingPage(
            title: "Track Your Progress",
            description: "Monitor your daily achievements and see how your habits improve over time with detailed analytics.",
            imageName: "chart.line.uptrend.xyaxis",
            color: AppColors.lightGreen
        ),
        OnboardingPage(
            title: "Stay Motivated",
            description: "Get personalized reminders and unlock achievements as you build a healthier lifestyle.",
            imageName: "trophy.fill",
            color: AppColors.accentYellow
        )
    ]
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: AppSpacing.xl) {
                Spacer()
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 400)
                
                Spacer()

                HStack(spacing: AppSpacing.sm) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? AppColors.accentYellow : AppColors.textSecondary.opacity(0.3))
                            .frame(width: 10, height: 10)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                                
                VStack(spacing: AppSpacing.md) {
                    if currentPage < pages.count - 1 {
                        Button {
                            withAnimation(.easeInOut) {
                                currentPage += 1
                            }
                        } label: {
                            Text("Next")
                                .font(AppFonts.button())
                                .foregroundColor(AppColors.textLight)
                                .padding(.vertical, AppSpacing.md)
                                .frame(maxWidth: .infinity)
                                .background(AppColors.accentYellow)
                                .cornerRadius(AppRadius.lg)
                        }
                        
                        Button("Skip") {
                            isShowingOnboarding = true
                            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                        }
                        .font(AppFonts.body())
                        .foregroundColor(AppColors.textSecondary)
                    } else {
                        Button {
                            isShowingOnboarding = true
                            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                        } label: {
                            Text("Get Started")
                                .font(AppFonts.button())
                                .foregroundColor(AppColors.textLight)
                                .padding(.vertical, AppSpacing.md)
                                .frame(maxWidth: .infinity)
                                .background(AppColors.accentYellow)
                                .cornerRadius(AppRadius.lg)
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, AppSpacing.xl)
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: AppSpacing.xl) {
            Image(systemName: page.imageName)
                .font(.system(size: 80))
                .foregroundColor(page.color)
                .padding(.bottom, AppSpacing.lg)
            
            Text(page.title)
                .font(AppFonts.title1())
                .foregroundColor(AppColors.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.lg)
            
            Text(page.description)
                .font(AppFonts.body())
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.xl)
        }
        .padding(AppSpacing.lg)
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
    let color: Color
}

#Preview {
    OnboardingView(isShowingOnboarding: .constant(true))
}
