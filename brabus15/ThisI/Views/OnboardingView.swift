import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var viewModel: DecisionViewModel
    @State private var currentPage = 0
    @State private var showMainApp = false
    @Binding var isCompleted: Bool
    
    private let pages = [
        OnboardingPage(
            title: "Capture decisions as clear facts.",
            description: "This app helps you record decisions exactly as they happen. Write down the situation, note the option you chose, and keep everything in a clean, neutral list.",
            systemImage: "doc.text"
        ),
        OnboardingPage(
            title: "Stay organized and factual.",
            description: "Each entry stays factual, without judging outcomes or giving advice. Browse your decision history, open any record in full, edit details, or quickly find past choices.",
            systemImage: "folder.badge.questionmark"
        ),
        OnboardingPage(
            title: "Clear overview of your choices.",
            description: "Get a clear overview of how you decided in similar situations. Search through your decisions and learn from your decision-making patterns.",
            systemImage: "magnifyingglass.circle"
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
                
                VStack(spacing: DesignSystem.Spacing.lg) {
                    HStack(spacing: DesignSystem.Spacing.sm) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? DesignSystem.Colors.yellow : DesignSystem.Colors.primaryText.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .scaleEffect(index == currentPage ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    Button(action: handleContinueAction) {
                        HStack {
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                                .font(DesignSystem.Typography.headline)
                                .foregroundColor(.black)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.black)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(DesignSystem.Gradients.buttonGradient)
                        .cornerRadius(DesignSystem.CornerRadius.medium)
                        .shadow(color: DesignSystem.Shadows.button, radius: 4, x: 0, y: 2)
                    }
                    .padding(.horizontal, DesignSystem.Spacing.lg)
                    
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            completeOnboarding()
                        }
                        .font(DesignSystem.Typography.callout)
                        .foregroundColor(DesignSystem.Colors.secondaryText)
                    }
                }
                .padding(.bottom, DesignSystem.Spacing.xl)
            }
        }
    }
    
    private func handleContinueAction() {
        if currentPage < pages.count - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentPage += 1
            }
        } else {
            completeOnboarding()
        }
    }
    
    private func completeOnboarding() {
        viewModel.completeOnboarding()
        isCompleted = true
        UserDefaults.standard.set(true, forKey: "isCompleted")
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
        VStack(spacing: DesignSystem.Spacing.xl) {
            Spacer()
            
            Image(systemName: page.systemImage)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(DesignSystem.Colors.yellow)
                .padding(.bottom, DesignSystem.Spacing.lg)
            
            Text(page.title)
                .font(DesignSystem.Typography.largeTitle)
                .foregroundColor(DesignSystem.Colors.primaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, DesignSystem.Spacing.lg)
            
            Text(page.description)
                .font(DesignSystem.Typography.body)
                .foregroundColor(DesignSystem.Colors.secondaryText)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, DesignSystem.Spacing.xl)
            
            Spacer()
        }
    }
}
