import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    let onComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            title: "Keep your personal items organized",
            description: "This app helps you store clear information about your personal belongings in one place.",
            systemImage: "house.fill"
        ),
        OnboardingPage(
            title: "Add and categorize",
            description: "Add tools, devices, clothing, or accessories with notes and key characteristics.",
            systemImage: "plus.circle.fill"
        ),
        OnboardingPage(
            title: "Browse and search",
            description: "Browse your catalog, open any item in full, edit details, or quickly search through your collection.",
            systemImage: "magnifyingglass.circle.fill"
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
                .animation(.easeInOut, value: currentPage)
                
                HStack(spacing: 12) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? ColorTheme.primaryYellow : ColorTheme.primaryBlue.opacity(0.3))
                            .frame(width: 12, height: 12)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3), value: currentPage)
                    }
                }
                .padding(.vertical, 20)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    } else {
                        onComplete()
                    }
                }) {
                    HStack {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(ColorTheme.textPrimary)
                        
                        if currentPage < pages.count - 1 {
                            Image(systemName: "arrow.right")
                                .foregroundColor(ColorTheme.textPrimary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(ColorTheme.primaryButtonGradient)
                    .cornerRadius(12)
                    .shadow(color: ColorTheme.primaryYellow.opacity(0.3), radius: 8, x: 0, y: 4)
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
            
            Image(systemName: page.systemImage)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorTheme.primaryBlue)
                .padding(.bottom, 20)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.playfairDisplay(28, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Text(page.description)
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
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
    let systemImage: String
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
