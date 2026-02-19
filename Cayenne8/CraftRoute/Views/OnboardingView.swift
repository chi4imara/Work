import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appViewModel: AppViewModel
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            image: "hammer.fill",
            title: "Track your tool-based projects",
            description: "This app helps you keep a clear record of every project you work on. Add tools, materials, dates and notes to build a complete history."
        ),
        OnboardingPage(
            image: "wrench.and.screwdriver.fill",
            title: "Organize Your Workflow",
            description: "A simple way to see what you've done, which instruments you used and how your workflow evolves."
        ),
        OnboardingPage(
            image: "list.clipboard.fill",
            title: "Never Forget Details",
            description: "Keep track of materials, tools, and project notes all in one place. Your complete project history at your fingertips."
        )
    ]
    
    var body: some View {
        ZStack {
            ColorManager.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(maxHeight: .infinity)
                
                VStack(spacing: 20) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? ColorManager.accentOrange : ColorManager.primaryText.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentPage += 1
                            }
                        } else {
                            appViewModel.completeOnboarding()
                        }
                    }) {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(ColorManager.primaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(ColorManager.accentOrange)
                            )
                    }
                    .padding(.horizontal, 32)
                }
                .padding(.bottom, 50)
            }
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
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorManager.accentBlue)
                .frame(height: 120)
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(appViewModel: AppViewModel())
}
