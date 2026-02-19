import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: TaskViewModel
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    private let pages = [
        OnboardingPage(
            title: "Keep your daily tasks in order.",
            description: "This app gives you a simple way to organize your everyday tasks. Add what you need to do, group it by categories, switch between days and keep everything clear and structured. No distractions — just your list, your pace, and your daily routine in one place.",
            imageName: "checkmark.circle.fill",
            color: AppColors.lightBlue
        ),
        OnboardingPage(
            title: "Organize by Categories",
            description: "Group your tasks by Home, Work, Personal, Shopping, and Hobby categories. Keep everything organized and find what you need quickly.",
            imageName: "folder.fill",
            color: AppColors.orange
        ),
        OnboardingPage(
            title: "Track Your Progress",
            description: "Mark tasks as complete, add notes, and switch between different days. Your productivity journey starts here.",
            imageName: "chart.line.uptrend.xyaxis",
            color: AppColors.homeCategory
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index], isAnimating: $isAnimating)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: AppSpacing.lg) {
                    HStack(spacing: AppSpacing.sm) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.lightBlue : AppColors.secondaryText)
                                .frame(width: 10, height: 10)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    .padding(.bottom, AppSpacing.md)
                    
                    HStack(spacing: AppSpacing.md) {
                        if currentPage > 0 {
                            Button {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentPage -= 1
                                }
                            } label: {
                                Text("Back")
                                    .font(AppTypography.body)
                                    .foregroundColor(AppColors.accentText)
                                    .padding(.horizontal, AppSpacing.lg)
                                    .padding(.vertical, AppSpacing.md)
                                    .frame(maxWidth: .infinity)
                                    .background(AppColors.cardBackgroundSecondary)
                                    .cornerRadius(AppRadius.small)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AppRadius.small)
                                            .stroke(AppColors.lightBlue, lineWidth: 1)
                                    )
                            }
                            
                            Spacer()
                        }
                        
                        Button {
                            if currentPage == pages.count - 1 {
                                viewModel.completeOnboarding()
                            } else {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentPage += 1
                                }
                            }
                        } label: {
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                                .font(AppTypography.body)
                                .foregroundColor(AppColors.primaryText)
                                .padding(.horizontal, AppSpacing.lg)
                                .padding(.vertical, AppSpacing.md)
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(
                                        colors: [AppColors.lightBlue, AppColors.orange],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(AppRadius.medium)
                                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.bottom, AppSpacing.xl)
                }
            }
        }
        .onAppear {
            isAnimating = true
        }
        .onChange(of: currentPage) { _ in
            isAnimating = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isAnimating = true
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
    @Binding var isAnimating: Bool
    
    var body: some View {
        VStack(spacing: 22) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(page.color)
                .scaleEffect(isAnimating ? 1.0 : 0.5)
                .opacity(isAnimating ? 1.0 : 0.3)
                .animation(.easeOut(duration: 0.8).delay(0.2), value: isAnimating)
            
            VStack(spacing: AppSpacing.lg) {
                Text(page.title)
                    .font(AppTypography.largeTitle)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: isAnimating)
                
                Text(page.description)
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, AppSpacing.lg)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: isAnimating)
            }
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.lg)
    }
}

#Preview {
    OnboardingView(viewModel: TaskViewModel())
}
