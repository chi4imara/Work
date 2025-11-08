import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showMainApp = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    let pages = [
        OnboardingPage(
            title: "Track Your Home Purchases",
            description: "Your home is full of things that matter — furniture, appliances, and devices you rely on every day. But how often do you forget when they were bought or how long they'll last?",
            systemImage: "house.fill"
        ),
        OnboardingPage(
            title: "Organize Everything",
            description: "With this app, you can organize every purchase: add the name, purchase date, service life, and personal notes. Over time, you'll build a clear catalog of your household items.",
            systemImage: "list.bullet.clipboard.fill"
        ),
        OnboardingPage(
            title: "Smart Features",
            description: "⭐ Mark important purchases as favorites.\n🔍 Search and filter by categories or years.\n📊 Explore simple statistics: how many purchases you've made, which ones are close to replacement, and what categories fill your home.\n\nIt's your personal household manager — keeping everything structured and easy to track.",
            systemImage: "star.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
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
                                .fill(currentPage == index ? Color.primaryYellow : Color.white.opacity(0.5))
                                .frame(width: 10, height: 10)
                                .animation(.easeInOut, value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            hasSeenOnboarding = true
                            showMainApp = true
                        }
                    }) {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(.bodyLarge)
                            .foregroundColor(.primaryBlue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.primaryYellow)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
        }
        .fullScreenCover(isPresented: $showMainApp) {
            MainTabView()
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
                .font(.system(size: 80))
                .foregroundColor(.primaryYellow)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.titleLarge)
                    .foregroundColor(.primaryWhite)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.bodyMedium)
                    .foregroundColor(.primaryWhite.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
}
