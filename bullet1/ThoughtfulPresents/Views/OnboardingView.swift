import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var isOnboardingComplete: Bool
    
    private let pages = [
        OnboardingPage(
            title: "Remember Every Gift Idea",
            description: "This app keeps all your gift ideas in one place — who they're for, what the idea is, the occasion, and even how much it might cost.",
            imageName: "lightbulb.fill",
            color: Color.theme.primaryBlue
        ),
        OnboardingPage(
            title: "Stay Organized",
            description: "You can save an idea, mark it as bought or already gifted, and see your entire plan at a glance. Each person has their own list of ideas.",
            imageName: "list.clipboard.fill",
            color: Color.theme.accentOrange
        ),
        OnboardingPage(
            title: "Never Forget Again",
            description: "Simple filters help you focus on upcoming events or organize your list by price or person. It's the easiest way to plan gifts thoughtfully and always be ready when the next special occasion arrives.",
            imageName: "calendar.badge.checkmark",
            color: Color.theme.accentPurple
        )
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.theme.backgroundGradientStart, Color.theme.backgroundGradientEnd]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
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
                
                VStack(spacing: 20) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.theme.primaryBlue : Color.theme.primaryBlue.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut, value: currentPage)
                        }
                    }
                    .padding(.bottom, 10)
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            isOnboardingComplete = true
                        }
                    }) {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(.theme.buttonLarge)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.theme.primaryBlue)
                            .cornerRadius(25)
                    }
                    .padding(.horizontal, 40)
                    
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            isOnboardingComplete = true
                        }
                        .font(.theme.body)
                        .foregroundColor(Color.theme.secondaryText)
                    }
                }
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(page.color)
                .padding(.bottom, 20)
            
            Text(page.title)
                .font(.theme.largeTitle)
                .foregroundColor(Color.theme.primaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Text(page.description)
                .font(.theme.body)
                .foregroundColor(Color.theme.secondaryText)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(isOnboardingComplete: .constant(false))
}
