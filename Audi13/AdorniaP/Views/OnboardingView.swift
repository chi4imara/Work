import SwiftUI

struct OnboardingView: View {
    @ObservedObject var navigationViewModel: NavigationViewModel
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.theme.backgroundGradientStart, Color.theme.backgroundGradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            AnimatedBackground()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPage(
                        icon: "sparkles",
                        title: "Save your favorite jewelry combinations",
                        description: "Create a personal archive of jewelry combinations you love. Save pairs and full sets, add short notes, and quickly recall which pieces work perfectly together.",
                        pageIndex: 0,
                        currentPage: $currentPage
                    )
                    .tag(0)
                    
                    OnboardingPage(
                        icon: "wand.and.stars",
                        title: "Smart selection by occasion",
                        description: "Find the perfect combination for any moment. Use our smart selection feature to discover combinations that match your occasion - from everyday wear to special events.",
                        pageIndex: 1,
                        currentPage: $currentPage
                    )
                    .tag(1)
                    
                    OnboardingPage(
                        icon: "heart.fill",
                        title: "Organize and discover",
                        description: "Mark your favorite combinations, track trends, and build your personal jewelry style. This app helps you keep your favorite combinations organized and ready whenever you need inspiration.",
                        pageIndex: 2,
                        currentPage: $currentPage
                    )
                    .tag(2)
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                VStack(spacing: 20) {
                    Button(action: {
                        if currentPage < 2 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            navigationViewModel.completeOnboarding()
                        }
                    }) {
                        HStack {
                            Text(currentPage < 2 ? "Next" : "Get Started")
                                .font(.bauhausBold(18))
                                .foregroundColor(Color.theme.buttonText)
                            
                            Image(systemName: currentPage < 2 ? "arrow.right" : "checkmark")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color.theme.buttonText)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.theme.buttonBackground)
                        .cornerRadius(28)
                        .shadow(color: Color.theme.cardShadow, radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                }
            }
        }
    }
}

struct OnboardingPage: View {
    let icon: String
    let title: String
    let description: String
    let pageIndex: Int
    @Binding var currentPage: Int
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.theme.primaryBlue.opacity(0.1))
                    .frame(width: 200, height: 200)
                
                Image(systemName: icon)
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(Color.theme.primaryBlue)
            }
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.bauhausBold(28))
                    .foregroundColor(Color.theme.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text(description)
                    .font(.bauhausRegular(16))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .lineSpacing(4)
            }
            
            Spacer()
        }
    }
}
