import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    let onComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            title: "Your Home Skincare",
            description: "Plan procedures and take care of your skin regularly.",
            icon: "heart.circle.fill"
        ),
        OnboardingPage(
            title: "Track Changes",
            description: "Record your skin condition and observe the results.",
            icon: "chart.line.uptrend.xyaxis.circle.fill"
        ),
        OnboardingPage(
            title: "Regularity is the Key to Beauty",
            description: "Mark completed procedures and create sustainable skincare habits.",
            icon: "calendar.circle.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
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
                
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? ColorManager.primaryBlue : ColorManager.primaryBlue.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                .padding(.bottom, 40)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        onComplete()
                    }
                }) {
                    Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                        .font(.titleSmall)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [ColorManager.primaryBlue, ColorManager.primaryYellow]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(25)
                        .shadow(color: ColorManager.shadowColor, radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 40)
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
            
            Image(systemName: page.icon)
                .font(.system(size: 80))
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [ColorManager.primaryBlue, ColorManager.primaryYellow]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: ColorManager.shadowColor, radius: 10, x: 0, y: 5)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.titleLarge)
                    .foregroundColor(ColorManager.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Text(page.description)
                    .font(.bodyLarge)
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .lineSpacing(4)
            }
            
            Spacer()
            Spacer()
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let icon: String
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
