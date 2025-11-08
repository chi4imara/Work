import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            title: "Bring Fun to Every Party",
            description: "This app is your generator of fun tasks for parties. With just one tap, you'll get a random challenge like 'sing a song', 'act like an animal', or 'dance for 10 seconds'.",
            systemImage: "party.popper.fill"
        ),
        OnboardingPage(
            title: "Create Your Collection",
            description: "You can add your own tasks, group them by categories, and keep them ready for the next game night. Over time, your collection grows into a party playbook filled with laughter and creativity.",
            systemImage: "square.and.pencil"
        ),
        OnboardingPage(
            title: "Simple & Entertaining",
            description: "Simple, fast, and entertaining — the perfect tool to make any party unforgettable. Start creating memories today!",
            systemImage: "heart.fill"
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
                
                VStack(spacing: 30) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.theme.accentOrange : Color.theme.secondaryText)
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
                            showOnboarding = false
                        }
                    }) {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(.nunitoSemiBold(size: 18))
                            .foregroundColor(Color.theme.buttonText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.theme.buttonPrimary)
                            .cornerRadius(28)
                    }
                    .padding(.horizontal, 40)
                }
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
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.systemImage)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(Color.theme.accentYellow)
                .shadow(color: Color.theme.accentYellow.opacity(0.3), radius: 10, x: 0, y: 5)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.nunitoBold(size: 28))
                    .foregroundColor(Color.theme.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.nunitoRegular(size: 16))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
