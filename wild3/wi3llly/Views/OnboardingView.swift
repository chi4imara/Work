import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    let pages = [
        OnboardingPage(
            title: "Capture Your Unusual Dreams",
            description: "This app is your private diary for strange and unusual dreams. Each morning, you can quickly log what you saw in your sleep — whether it's surreal images, repeating patterns, or strange feelings.",
            imageName: "moon.stars.fill"
        ),
        OnboardingPage(
            title: "Organize with Tags",
            description: "Add tags like 'flying', 'water', or 'fear' to keep track of recurring themes. Over time, you'll build a personal archive of dreams to explore and reflect on.",
            imageName: "tag.fill"
        ),
        OnboardingPage(
            title: "Your Private Space",
            description: "No sharing, no noise — just your own record of the mysteries of the night. Start your dream journey today.",
            imageName: "lock.shield.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            BackgroundView()
            
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
                                .fill(currentPage == index ? Color.app.primaryPurple : Color.app.textTertiary)
                                .frame(width: 8, height: 8)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.spring(response: 0.3), value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage += 1
                            }
                        } else {
                            hasSeenOnboarding = true
                        }
                    }) {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(.builderSans(.semiBold, size: 18))
                            .foregroundColor(Color.app.buttonText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.app.buttonBackground)
                            )
                    }
                    .padding(.horizontal, 32)
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
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(Color.white)
                .padding(.bottom, 20)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.builderSans(.bold, size: 28))
                    .foregroundColor(Color.app.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                Text(page.description)
                    .font(.builderSans(.regular, size: 16))
                    .foregroundColor(Color.app.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
}

