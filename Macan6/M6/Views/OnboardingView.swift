import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var isOnboardingCompleted: Bool
    
    private let pages = [
        OnboardingPage(
            title: "Test. Review. Remember.",
            description: "Keep track of every product you try — from skincare to makeup — and record how it actually worked for you.",
            imageName: "list.bullet.clipboard"
        ),
        OnboardingPage(
            title: "Rate & Organize",
            description: "Add your impressions, rate the results, and mark what's worth buying again. Sort by skin or hair type to see what fits you best.",
            imageName: "star.fill"
        ),
        OnboardingPage(
            title: "Build Your Knowledge",
            description: "Build your personal beauty knowledge base. No more guessing or repeating failed purchases — just your honest experience, organized in one simple app.",
            imageName: "brain.head.profile"
        )
    ]
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? AppColors.yellow : AppColors.primaryText.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .scaleEffect(index == currentPage ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.vertical, 20)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage += 1
                        }
                    } else {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isOnboardingCompleted = true
                        }
                    }
                }) {
                    Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(AppColors.accentText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(AppColors.yellow)
                        )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.yellow)
                .padding(.bottom, 20)
            
            Text(page.title)
                .font(.playfairDisplay(32, weight: .bold))
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            Text(page.description)
                .font(.playfairDisplay(16, weight: .regular))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(isOnboardingCompleted: .constant(false))
}
