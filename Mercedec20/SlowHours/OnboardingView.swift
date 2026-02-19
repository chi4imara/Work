import SwiftUI

struct OnboardingView: View {
    var onComplete: () -> Void
    @State private var currentPage = 0
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Make time for yourself",
            description: "Plan enjoyable activities, track your leisure, and maintain balance in your daily life.",
            icon: "heart.fill"
        ),
        OnboardingPage(
            title: "Track your leisure",
            description: "Schedule activities, mark them completed, and add notes about your impressions.",
            icon: "calendar.badge.clock"
        ),
        OnboardingPage(
            title: "Balance and inspiration",
            description: "Maintain energy and inspiration every day. See your progress and achievements.",
            icon: "chart.line.uptrend.xyaxis"
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
                
                VStack(spacing: 24) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? ColorTheme.primaryBlue : ColorTheme.lightBlue.opacity(0.5))
                                .frame(width: 8, height: 8)
                        }
                    }
                    
                    if currentPage == pages.count - 1 {
                        Button(action: onComplete) {
                            Text("Get Started")
                                .font(.playfair(18, weight: .semibold))
                                .foregroundColor(ColorTheme.primaryText)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(ColorTheme.buttonGradient)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: ColorTheme.primaryYellow.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal, 32)
                    } else {
                        Button(action: {
                            withAnimation {
                                currentPage += 1
                            }
                        }) {
                            Text("Next")
                                .font(.playfair(18, weight: .semibold))
                                .foregroundColor(ColorTheme.primaryText)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(ColorTheme.buttonGradient)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: ColorTheme.primaryYellow.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal, 32)
                    }
                }
                .padding(.bottom, 48)
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let icon: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: page.icon)
                .font(.system(size: 80))
                .foregroundColor(ColorTheme.primaryBlue)
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.playfair(28, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.playfair(18))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 24)
            }
            
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(onComplete: {})
}
