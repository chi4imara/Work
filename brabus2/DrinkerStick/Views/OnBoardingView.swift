import SwiftUI

struct OnBoardingView: View {
    @Binding var isOnboardingComplete: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                OnBoardingPage(
                    imageName: "wineglass.fill",
                    title: "Build your personal archive of fine drinks.",
                    description: "Create a refined, well-organized catalog of your favorite drinks. Add bottles with details about strength, origin, type, and your personal tasting notes.",
                    pageIndex: 0
                )
                .tag(0)
                
                OnBoardingPage(
                    imageName: "chart.bar.fill",
                    title: "Explore your collection",
                    description: "Explore your growing collection, revisit past entries and keep every impression preserved in one clear, elegant place.",
                    pageIndex: 1
                )
                .tag(1)
                
                OnBoardingPage(
                    imageName: "magnifyingglass",
                    title: "Search and filter",
                    description: "Quickly find your favorite drinks using powerful search and filter tools. Filter by type, country, strength, or search by name to discover what you're looking for.",
                    pageIndex: 2
                )
                .tag(2)
                
                OnBoardingPage(
                    imageName: "calendar",
                    title: "Track your journey",
                    description: "View your collection through time with the calendar view. See when you added each drink and track your tasting journey over the months.",
                    pageIndex: 3
                )
                .tag(3)
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            VStack {
                Spacer()
                
                Button(action: {
                    if currentPage < 3 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        completeOnboarding()
                    }
                }) {
                    HStack {
                        Text(currentPage < 3 ? "Continue" : "Get Started")
                            .font(.playfair(18, weight: .semibold))
                            .foregroundColor(ColorTheme.buttonText)
                        
                        if currentPage < 3 {
                            Image(systemName: "arrow.right")
                                .foregroundColor(ColorTheme.buttonText)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(ColorTheme.buttonBackground)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
    
    private func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        withAnimation {
            isOnboardingComplete = true
        }
    }
}

struct OnBoardingPage: View {
    let imageName: String
    let title: String
    let description: String
    let pageIndex: Int
    
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                ColorTheme.primaryPink.opacity(0.3),
                                ColorTheme.accentPurple.opacity(0.3)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 200, height: 200)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .opacity(isAnimating ? 0.8 : 1.0)
                
                Image(systemName: imageName)
                    .font(.system(size: 80))
                    .foregroundColor(ColorTheme.primaryPink)
                    .scaleEffect(isAnimating ? 1.05 : 1.0)
            }
            .padding(.bottom, 40)
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.playfair(28, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Text(description)
                    .font(.playfair(16, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            Spacer()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    OnBoardingView(isOnboardingComplete: .constant(false))
}
