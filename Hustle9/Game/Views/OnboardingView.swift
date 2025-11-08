import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showMainApp = false
    
    private let pages = [
        OnboardingPage(
            title: "Your Rules Library",
            description: "This app is your personal collection of board game rules. Forget about lost papers or searching online — now every rulebook can be stored in one place, written by you.",
            systemImage: "book.fill"
        ),
        OnboardingPage(
            title: "Organize & Categorize",
            description: "Create your own entries for each game, structure them into categories, add details and notes, and always keep your favorite games ready to play.",
            systemImage: "folder.fill"
        ),
        OnboardingPage(
            title: "Simple & Personal",
            description: "Simple, personal, and organized — your rules, your way. Start building your game library today!",
            systemImage: "heart.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            if showMainApp {
                MainTabView()
            } else {
                BackgroundView()
                
                VStack(spacing: 0) {
                    TabView(selection: $currentPage) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            OnboardingPageView(page: pages[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                    VStack(spacing: 24) {
                        HStack(spacing: 8) {
                            ForEach(0..<pages.count, id: \.self) { index in
                                Circle()
                                    .fill(currentPage == index ? AppColors.accent : AppColors.primaryText.opacity(0.3))
                                    .frame(width: 8, height: 8)
                                    .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                    .animation(.easeInOut(duration: 0.3), value: currentPage)
                            }
                        }
                        
                        Button(action: {
                            if currentPage < pages.count - 1 {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentPage += 1
                                }
                            } else {
                                UserDefaults.standard.set(true, forKey: "HasSeenOnboarding")
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    showMainApp = true
                                }
                            }
                        }) {
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                                .font(AppFonts.buttonLarge)
                                .foregroundColor(AppColors.primaryText)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(AppColors.accent)
                                )
                        }
                        .padding(.horizontal, 32)
                    }
                    .padding(.bottom, 50)
                }
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
                .font(.system(size: 80))
                .foregroundColor(AppColors.accent)
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(AppFonts.largeTitle)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
}
