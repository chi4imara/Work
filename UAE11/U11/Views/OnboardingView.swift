import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var showOnboarding: Bool
    
    private let pages = [
        OnboardingPage(
            title: "Track your strength with clarity",
            description: "This app lets you record the weights you use in every exercise and see how your strength grows over time.",
            imageName: "figure.strengthtraining.traditional"
        ),
        OnboardingPage(
            title: "Log your results quickly",
            description: "Review your progress, and stay consistent with simple tools built for focused training.",
            imageName: "chart.line.uptrend.xyaxis"
        ),
        OnboardingPage(
            title: "Every entry shows your path",
            description: "Every entry turns into a clear path showing how far your discipline takes you.",
            imageName: "target"
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                VStack(spacing: 30) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.lightBlue : AppColors.primaryText.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage += 1
                            }
                        } else {
                            showOnboarding = false
                        }
                    }) {
                        Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                            .font(.playfairDisplay(size: 18, weight: .semibold))
                            .foregroundColor(AppColors.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.lightBlue)
                            )
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.lightBlue)
                .padding(.bottom, 20)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Text(page.description)
                    .font(.playfairDisplay(size: 16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
