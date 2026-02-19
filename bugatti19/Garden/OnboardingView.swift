import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    let onComplete: () -> Void
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Track Your Energy",
            description: "Monitor your sleep, nutrition and activity for better well-being every day.",
            systemImage: "bolt.heart"
        ),
        OnboardingPage(
            title: "Small Habits, Big Results",
            description: "Create daily goals and mini-challenges to feel your progress.",
            systemImage: "target"
        ),
        OnboardingPage(
            title: "Start Taking Care of Yourself",
            description: "Complete mini-tasks, get visual rewards and micro-support.",
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
                
                HStack(spacing: AppSpacing.sm) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? AppColors.iconAccent : AppColors.primaryWhite.opacity(0.3))
                            .frame(width: 10, height: 10)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, AppSpacing.xl)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    } else {
                        onComplete()
                    }
                }) {
                    HStack {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(AppFonts.headline())
                            .foregroundColor(AppColors.iconSecondary)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppColors.iconSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(AppColors.iconAccent)
                    .cornerRadius(AppCornerRadius.lg)
                    .shadow(color: AppShadows.medium, radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, AppSpacing.xl)
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -50 && currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    } else if value.translation.width > 50 && currentPage > 0 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage -= 1
                        }
                    }
                }
        )
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var isAnimated = false
    
    var body: some View {
        VStack(spacing: AppSpacing.xl) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.primaryYellow.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .scaleEffect(isAnimated ? 1.0 : 0.8)
                
                Image(systemName: page.systemImage)
                    .font(.system(size: 48, weight: .medium))
                    .foregroundColor(AppColors.iconAccent)
                    .scaleEffect(isAnimated ? 1.0 : 0.6)
            }
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isAnimated)
            
            VStack(spacing: AppSpacing.lg) {
                Text(page.title)
                    .font(AppFonts.title1())
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimated ? 1.0 : 0.0)
                    .offset(y: isAnimated ? 0 : 20)
                
                Text(page.description)
                    .font(AppFonts.body())
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .opacity(isAnimated ? 1.0 : 0.0)
                    .offset(y: isAnimated ? 0 : 30)
            }
            .padding(.horizontal, AppSpacing.lg)
            
            Spacer()
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                isAnimated = true
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let systemImage: String
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
