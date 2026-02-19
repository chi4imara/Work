import SwiftUI

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            icon: "figure.strengthtraining.traditional",
            title: "Build discipline with clear bodyweight tracking.",
            description: "This app helps you log bodyweight exercises such as push-ups, planks, and core work. Track each session, review detailed results, and follow your progress with structured graphs and clean records.",
            color: AppColors.lightBlue
        ),
        OnboardingPage(
            icon: "chart.line.uptrend.xyaxis",
            title: "Monitor Your Progress",
            description: "Stay consistent and keep improving your training routine with simple, focused tracking tools. Watch your strength grow over time with detailed analytics.",
            color: AppColors.orange
        ),
        OnboardingPage(
            icon: "target",
            title: "Achieve Your Goals",
            description: "Set personal records, track your best results, and maintain consistency in your fitness journey. Every workout counts towards your success.",
            color: AppColors.accent
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
                
                bottomSection
            }
        }
    }
    
    private var bottomSection: some View {
        VStack(spacing: 20) {
            HStack(spacing: 8) {
                ForEach(0..<pages.count, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? AppColors.orange : AppColors.primaryText.opacity(0.3))
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
                    hasSeenOnboarding = true
                }
            }) {
                Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                    .font(.ubuntu(.medium, size: 18))
                    .foregroundColor(AppColors.primaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(AppColors.buttonGradient)
                    )
            }
            .padding(.horizontal, 40)
            
            if currentPage < pages.count - 1 {
                Button(action: {
                    hasSeenOnboarding = true
                }) {
                    Text("Skip")
                        .font(.ubuntu(.regular, size: 16))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
        }
        .padding(.bottom, 50)
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: page.icon)
                    .font(.system(size: 48, weight: .medium))
                    .foregroundColor(page.color)
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.ubuntu(.bold, size: 28))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(.ubuntu(.regular, size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    OnboardingView(hasSeenOnboarding: .constant(false))
}
