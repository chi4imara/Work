import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appViewModel: AppViewModel
    @State private var currentPage = 0
    private let totalPages = 3
    
    var body: some View {
        ZStack {
            ColorScheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPage(
                        imageName: "leaf.fill",
                        title: "Care for your plants with ease",
                        description: "Turn plant care into a simple and organized routine. This app helps you keep track of watering, fertilizing, repotting, and other tasks — so your plants always stay healthy and beautiful."
                    )
                    .tag(0)
                    
                    OnboardingPage(
                        imageName: "calendar",
                        title: "Never miss a care task",
                        description: "On the main calendar, you'll see all upcoming care tasks for each day. Choose a date, and instantly view what needs to be done — from watering your flowers to cleaning your aquarium filters."
                    )
                    .tag(1)
                    
                    OnboardingPage(
                        imageName: "book.fill",
                        title: "Step-by-step guidance",
                        description: "Each plant has its own card with care rules: how often to water, when to repot, what tools you'll need, and step-by-step instructions that make any task easy to follow. With clear organization, practical tips, and easy navigation, you'll always know how to give your plants the attention they need."
                    )
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack(spacing: 8) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? ColorScheme.accent : ColorScheme.mediumGray.opacity(0.5))
                            .frame(width: 8, height: 8)
                            .scaleEffect(index == currentPage ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.vertical, DesignConstants.largePadding)
                
                Button(action: {
                    if currentPage < totalPages - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    } else {
                        appViewModel.completeOnboarding()
                    }
                }) {
                    Text(currentPage == totalPages - 1 ? "Get Started" : "Continue")
                        .font(FontManager.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(ColorScheme.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DesignConstants.mediumPadding)
                        .background(
                            RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                                .fill(ColorScheme.accent)
                        )
                }
                .padding(.horizontal, DesignConstants.largePadding)
                .padding(.bottom, DesignConstants.largePadding)
            }
        }
    }
}

struct OnboardingPage: View {
    let imageName: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: DesignConstants.largePadding) {
            Spacer()
            
            Image(systemName: imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorScheme.accent)
                .padding(.bottom, DesignConstants.mediumPadding)
            
            Text(title)
                .font(FontManager.title)
                .fontWeight(.bold)
                .foregroundColor(ColorScheme.lightText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, DesignConstants.largePadding)
            
            Text(description)
                .font(FontManager.body)
                .foregroundColor(ColorScheme.lightText.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, DesignConstants.largePadding)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(appViewModel: AppViewModel())
}

