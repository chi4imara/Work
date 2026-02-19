import SwiftUI

struct OnboardingView: View {
    @Binding var isCompleted: Bool
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            title: "Plan every tech upgrade with clarity.",
            description: "Organize your entire setup—from PC parts to consoles and accessories—and map out each upgrade you want to make.",
            systemImage: "desktopcomputer"
        ),
        OnboardingPage(
            title: "Track your progress",
            description: "Add devices, list improvements, track progress and keep a clear offline plan for building the perfect tech configuration over time.",
            systemImage: "checkmark.circle.fill"
        ),
        OnboardingPage(
            title: "Organize by categories",
            description: "Easily manage your devices by categories: PC, Consoles, Peripherals, and Accessories. Find what you need quickly.",
            systemImage: "square.grid.2x2"
        ),
        OnboardingPage(
            title: "Stay organized offline",
            description: "All your data is stored locally on your device. No internet required. Your upgrade plan is always with you.",
            systemImage: "icloud.slash"
        )
    ]
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(maxHeight: .infinity)
                .padding(.bottom, 50)
            }
            
            VStack(spacing: 40) {
                Spacer()
                
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? ColorTheme.accentYellow : ColorTheme.primaryText.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut) {
                            currentPage += 1
                        }
                    } else {
                        withAnimation(.easeInOut) {
                            isCompleted = true
                            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                        }
                    }
                }) {
                    Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(ColorTheme.primaryText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(ColorTheme.accentYellow)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
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
        VStack(spacing: 30) {
            Image(systemName: page.systemImage)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorTheme.accentYellow)
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.ubuntu(16))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 32)
        }
    }
}

#Preview {
    OnboardingView(isCompleted: .constant(false))
}
