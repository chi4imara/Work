import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    let onComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            title: "Eat according to your mood and energy",
            description: "Discover meals and snacks tailored to your mood, track your energy, and build healthy eating habits effortlessly.",
            icon: "heart.fill",
            color: AppColors.energyColor
        ),
        OnboardingPage(
            title: "Personalized Recommendations",
            description: "Get meal suggestions based on your current energy level and desired mood goals.",
            icon: "sparkles",
            color: Color.green
        ),
        OnboardingPage(
            title: "Track Your Progress",
            description: "Monitor your energy levels and see how your nutrition affects your daily performance.",
            icon: "chart.line.uptrend.xyaxis",
            color: AppColors.relaxColor
        )
    ]
    
    var body: some View {
        ZStack {
            AppGradients.primaryBackground
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
                
                bottomSection
            }
        }
    }
    
    private var bottomSection: some View {
        VStack(spacing: AppSpacing.lg) {
            HStack(spacing: AppSpacing.sm) {
                ForEach(0..<pages.count, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? AppColors.accentYellow : AppColors.secondaryText)
                        .frame(width: 10, height: 10)
                        .scaleEffect(currentPage == index ? 1.2 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                }
            }
            
            HStack {
                if currentPage > 0 {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage -= 1
                        }
                    } label: {
                        Text("Back")
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.primaryText)
                            .padding(.horizontal, AppSpacing.xl)
                            .padding(.vertical, AppSpacing.md)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: AppRadius.medium)
                                    .fill(AppColors.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AppRadius.medium)
                                            .stroke(AppColors.cardBorder, lineWidth: 1)
                                    )
                            )
                    }
                }
                
                Button {
                    if currentPage == pages.count - 1 {
                        onComplete()
                    } else {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    }
                } label: {
                    Text(currentPage == pages.count - 1 ? "Get Started" : "Next")
                        .font(Font.ubuntu(17, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .padding(.horizontal, AppSpacing.xl)
                        .padding(.vertical, AppSpacing.md)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: AppRadius.medium)
                                .fill(AppColors.accentYellow)
                        )
                }
            }
            
            if currentPage < pages.count - 1 {
                Button {
                    onComplete()
                } label: {
                    Text("Skip")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.primaryText)
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.vertical, AppSpacing.md)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: AppRadius.medium)
                                .fill(AppColors.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppRadius.medium)
                                        .stroke(AppColors.cardBorder, lineWidth: 1)
                                )
                        )
                }
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.bottom, AppSpacing.xl)
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var animateIcon = false
    @State private var animateText = false
    
    var body: some View {
        VStack(spacing: AppSpacing.xxl) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .scaleEffect(animateIcon ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateIcon)
                
                Image(systemName: page.icon)
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(page.color)
                    .scaleEffect(animateIcon ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateIcon)
            }
            
            VStack(spacing: AppSpacing.lg) {
                Text(page.title)
                    .font(AppFonts.largeTitle)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .opacity(animateText ? 1.0 : 0.0)
                    .offset(y: animateText ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: animateText)
                
                Text(page.description)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .opacity(animateText ? 1.0 : 0.0)
                    .offset(y: animateText ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: animateText)
            }
            .padding(.horizontal, AppSpacing.lg)
            
            Spacer()
        }
        .onAppear {
            animateIcon = true
            animateText = true
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let icon: String
    let color: Color
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
