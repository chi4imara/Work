import SwiftUI

struct OnboardingView: View {
    let onComplete: () -> Void
    @State private var currentPage = 0
    @State private var animateContent = false
    
    private let pages = [
        OnboardingPage(
            title: "Spin. Play. Celebrate.",
            description: "Parties should be fun, spontaneous, and full of surprises — and that's exactly what this app is here for.",
            systemImage: "party.popper"
        ),
        OnboardingPage(
            title: "Wheel of Fortune",
            description: "With the Wheel of Fortune, you don't need to prepare endless lists of tasks or games. Just gather your friends, spin the wheel, and let it decide who sings, dances, or gives a toast.",
            systemImage: "circle.grid.cross"
        ),
        OnboardingPage(
            title: "Party Themes",
            description: "The Party Theme Generator gives you fresh, creative ideas to set the mood: from tropical nights and Hollywood glam to retro discos or mysterious masquerades.",
            systemImage: "theatermasks"
        ),
        OnboardingPage(
            title: "Your Favorites",
            description: "Your favorite themes and tasks can be saved in Favorites, so you'll never lose the best ideas. Statistics show how often you've used each feature.",
            systemImage: "heart.circle"
        )
    ]
    
    var body: some View {
        ZStack {
            StaticBackground()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(
                            page: pages[index],
                            isActive: currentPage == index
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                VStack(spacing: 30) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? ColorTheme.primaryBlue : ColorTheme.lightBlue.opacity(0.5))
                                .frame(width: 10, height: 10)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
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
                            Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                                .font(.theme.headline)
                                .foregroundColor(ColorTheme.textLight)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(ColorTheme.textLight)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(ColorTheme.buttonGradient)
                        .cornerRadius(28)
                        .shadow(color: ColorTheme.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 40)
                    
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            onComplete()
                        }
                        .font(.theme.callout)
                        .foregroundColor(ColorTheme.textSecondary)
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).delay(0.2)) {
                animateContent = true
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
    let isActive: Bool
    @State private var animateIcon = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(ColorTheme.blueGradient)
                    .frame(width: 120, height: 120)
                    .scaleEffect(animateIcon ? 1.0 : 0.8)
                    .opacity(animateIcon ? 1.0 : 0.7)
                
                Image(systemName: page.systemImage)
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(ColorTheme.textLight)
                    .scaleEffect(animateIcon ? 1.0 : 0.8)
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.theme.largeTitle)
                    .foregroundColor(ColorTheme.textPrimary)
                    .multilineTextAlignment(.center)
                    .opacity(animateIcon ? 1.0 : 0.0)
                
                Text(page.description)
                    .font(.theme.body)
                    .foregroundColor(ColorTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .opacity(animateIcon ? 1.0 : 0.0)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .onChange(of: isActive) { active in
            if active {
                withAnimation(.easeInOut(duration: 0.6).delay(0.1)) {
                    animateIcon = true
                }
            } else {
                animateIcon = false
            }
        }
        .onAppear {
            if isActive {
                withAnimation(.easeInOut(duration: 0.6).delay(0.1)) {
                    animateIcon = true
                }
            }
        }
    }
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
