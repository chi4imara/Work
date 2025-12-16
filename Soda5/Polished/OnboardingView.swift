import SwiftUI

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @State private var currentPage = 0
    @State private var showSplash = true
    
    private let pages = [
        OnboardingPage(
            title: "Keep your nail history organized.",
            description: "Track every manicure effortlessly. Enter the date, color, and salon or master — and watch your nail journey unfold.",
            systemImage: "paintbrush.fill"
        ),
        OnboardingPage(
            title: "Remember your favorites",
            description: "Each record helps you remember your past shades, find your favorite combinations, and avoid repeating the same look twice.",
            systemImage: "heart.fill"
        ),
        OnboardingPage(
            title: "Your personal style log",
            description: "Simple, elegant, and made for beauty enthusiasts — this tracker keeps your nail history organized and inspiring.",
            systemImage: "sparkles"
        )
    ]
    
    var body: some View {
        ZStack {
            onboardingContent
                .transition(.opacity)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showSplash = false
                }
            }
        }
    }
    
    private var onboardingContent: some View {
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
                
                HStack(spacing: 12) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? AppColors.yellowAccent : AppColors.secondaryText.opacity(0.3))
                            .frame(width: 10, height: 10)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.vertical, 20)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    } else {
                        hasSeenOnboarding = true
                    }
                }) {
                    Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(AppColors.contrastText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppColors.purpleGradient)
                        .cornerRadius(25)
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
    let systemImage: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.systemImage)
                .font(.system(size: 80))
                .foregroundColor(AppColors.yellowAccent)
                .padding(.bottom, 20)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.playfairDisplay(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Text(page.description)
                    .font(.playfairDisplay(16))
                    .foregroundColor(AppColors.blueText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            Spacer()
        }
    }
}
