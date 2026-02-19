import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @EnvironmentObject var productStore: ProductStore
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPageView(
                        imageName: "list.bullet.clipboard",
                        title: "Know your products at a glance.",
                        description: "This app helps you keep a personal list of products that work for you and those that don't. Add items in seconds, mark them clearly, and build your own reference for everyday choices."
                    )
                    .tag(0)
                    
                    OnboardingPageView(
                        imageName: "checkmark.circle",
                        title: "Simple & Clear",
                        description: "Your list grows with your experience and stays simple, clear, and easy to use. Never forget which products work for you again."
                    )
                    .tag(1)
                    
                    OnboardingPageView(
                        imageName: "magnifyingglass",
                        title: "Quick Search",
                        description: "Find any product instantly with our powerful search feature. Filter by status, browse your history, and access your favorites in seconds."
                    )
                    .tag(2)
                    
                    OnboardingPageView(
                        imageName: "chart.bar",
                        title: "Track Your Progress",
                        description: "Monitor your product choices with detailed statistics. See trends, track your preferences, and make informed decisions based on your personal data."
                    )
                    .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                VStack(spacing: 20) {
                    Button(action: {
                        if currentPage < 3 {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentPage += 1
                            }
                        } else {
                            completeOnboarding()
                        }
                    }) {
                        HStack {
                            Text(currentPage < 3 ? "Next" : "Get Started")
                                .font(.playfairDisplay(size: 18, weight: .semibold))
                                .foregroundColor(ColorManager.whiteText)
                            
                            if currentPage < 3 {
                                Image(systemName: "arrow.right")
                                    .foregroundColor(ColorManager.whiteText)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(ColorManager.buttonGradient)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 40)
                    
                    if currentPage > 0 {
                        Button("Skip") {
                            completeOnboarding()
                        }
                        .font(.playfairDisplay(size: 16, weight: .medium))
                        .foregroundColor(ColorManager.secondaryText)
                    }
                }
                .padding(.bottom, 50)
            }
        }
    }
    
    private func completeOnboarding() {
        withAnimation(.easeInOut(duration: 0.5)) {
            hasCompletedOnboarding = true
        }
    }
}

struct OnboardingPageView: View {
    let imageName: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: imageName)
                .font(.system(size: 70, weight: .light))
                .foregroundColor(ColorManager.primaryBlue)
                .padding(.top, 50)
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Text(description)
                    .font(.playfairDisplay(size: 16, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            Spacer()
        }
    }
}
