import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    
    private let pages: [(title: String, description: String, icon: String)] = [
        ("Find your perfect bag", "Discover bags that fit your style and outfit.", "handbag.fill"),
        ("Try virtual looks", "Save your favorites and try on bags in AR.", "camera.viewfinder"),
        ("Create stylish combinations", "Build your collection and get personalized recommendations effortlessly.", "heart.fill")
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.theme.gradientStart, Color.theme.gradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            GridPattern()
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(
                            title: pages[index].title,
                            description: pages[index].description,
                            icon: pages[index].icon
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.theme.accentYellow : Color.theme.primaryWhite.opacity(0.4))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 24)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        UserDefaultsStorage.shared.setOnboardingCompleted(true)
                        hasCompletedOnboarding = true
                    }
                }) {
                    Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.theme.primaryButton)
                        .cornerRadius(25)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
    }
}

struct OnboardingPageView: View {
    let title: String
    let description: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 80))
                .foregroundColor(Color.theme.accentYellow)
            
            VStack(spacing: 16) {
                Text(title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(hasCompletedOnboarding: .constant(false))
}
