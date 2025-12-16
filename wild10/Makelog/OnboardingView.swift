import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appViewModel: AppViewModel
    @State private var currentPage = 0
    @State private var opacity: Double = 0
    
    let pages = [
        OnboardingPage(
            icon: "cloud.sun.fill",
            title: "Record Weather in Your Words",
            description: "This app lets you create a personal weather diary. Each day, describe the weather in your own words — from sunny mornings to stormy nights."
        ),
        OnboardingPage(
            icon: "book.fill",
            title: "Build Your History",
            description: "Over time, you'll build a history of days, moods, and seasons. Simple, reflective, and personal."
        ),
        OnboardingPage(
            icon: "heart.fill",
            title: "Start Your Journey",
            description: "Ready to begin capturing the weather through your unique perspective? Let's create your first entry!"
        )
    ]
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: AppSpacing.xl) {
                Spacer()
                
                VStack(spacing: AppSpacing.lg) {
                    Image(systemName: pages[currentPage].icon)
                        .font(.system(size: 80, weight: .light))
                        .foregroundColor(AppColors.primaryWhite)
                        .opacity(opacity)
                        .scaleEffect(opacity)
                    
                    Text(pages[currentPage].title)
                        .font(AppFonts.largeTitle)
                        .foregroundColor(AppColors.textPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppSpacing.lg)
                        .opacity(opacity)
                    
                    Text(pages[currentPage].description)
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, AppSpacing.xl)
                        .opacity(opacity)
                }
                
                Spacer()
                
                HStack(spacing: AppSpacing.sm) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? AppColors.primaryWhite : AppColors.primaryWhite.opacity(0.3))
                            .frame(width: 10, height: 10)
                            .scaleEffect(index == currentPage ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                    }
                }
                .padding(.bottom, AppSpacing.lg)
                
                Button(action: handleContinueAction) {
                    HStack {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.buttonText)
                        
                        if currentPage < pages.count - 1 {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.buttonText)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                            .fill(AppColors.buttonBackground)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                            .stroke(AppColors.primaryWhite.opacity(0.3), lineWidth: 1)
                    )
                }
                .padding(.horizontal, AppSpacing.xl)
                .padding(.bottom, AppSpacing.xl)
                .opacity(opacity)
                .scaleEffect(opacity)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                opacity = 1.0
            }
        }
        .highPriorityGesture(
            DragGesture(minimumDistance: 20)
                .onEnded { value in
                    if value.translation.width < -50 && currentPage < pages.count - 1 {
                        nextPage()
                    } else if value.translation.width > 50 && currentPage > 0 {
                        previousPage()
                    }
                }
        )
    }
    
    private func handleContinueAction() {
        if currentPage < pages.count - 1 {
            nextPage()
        } else {
            appViewModel.completeOnboarding()
        }
    }
    
    private func nextPage() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            opacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            currentPage += 1
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                opacity = 1
            }
        }
    }
    
    private func previousPage() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            opacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            currentPage -= 1
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                opacity = 1
            }
        }
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
}

#Preview {
    OnboardingView(appViewModel: AppViewModel())
}
