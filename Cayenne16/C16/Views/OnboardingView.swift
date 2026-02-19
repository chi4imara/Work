import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var opacity = 0.0
    let onComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            title: "Keep your sneaker collection organized.",
            description: "Add every pair you own with purchase details and condition. Track how often you wear each pair, browse your full collection and keep everything well-organized. A simple way to manage your sneakers and follow your wearing habits day by day.",
            systemImage: "shippingbox.fill"
        ),
        OnboardingPage(
            title: "Track your wearing habits.",
            description: "Mark each day you wear your sneakers to build a complete history. See which pairs you use most frequently and discover your favorite models. Stay aware of your wearing patterns and make informed decisions about your collection.",
            systemImage: "calendar.badge.clock"
        ),
        OnboardingPage(
            title: "Analyze your collection.",
            description: "View detailed analytics about your sneaker collection. See statistics, condition distribution, and recent activity. Get insights into your wearing habits and keep your collection in perfect shape.",
            systemImage: "chart.bar.xaxis"
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
                
                VStack(spacing: 30) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? ColorManager.orange : ColorManager.lightBlue.opacity(0.3))
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
                            onComplete()
                        }
                    }) {
                        HStack {
                            Text(currentPage < pages.count - 1 ? "Next" : "Continue")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(ColorManager.primaryText)
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(ColorManager.primaryText)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [ColorManager.lightBlue, ColorManager.orange],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                opacity = 1.0
            }
        }
        .opacity(opacity)
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let systemImage: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(ColorManager.cardGradient)
                    .frame(width: 120, height: 120)
                
                Image(systemName: page.systemImage)
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(ColorManager.lightBlue)
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
