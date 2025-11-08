import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appViewModel: AppViewModel
    @State private var currentPage = 0
    @Binding var isOnboardingComplete: Bool
    
    private let pages = [
        OnboardingPage(
            title: "Find Fun at Home",
            subtitle: "Stay Inspired",
            description: "This app gives you quick ideas for spending your time at home. You'll see a ready list of activities — like reading, cooking, board games, or hobbies.",
            systemImage: "house.fill"
        ),
        OnboardingPage(
            title: "Organize Your Ideas",
            subtitle: "Stay Creative",
            description: "You can also add your own ideas and organize them into categories. Over time, your list becomes a personal catalog of fun and inspiration.",
            systemImage: "folder.fill"
        ),
        OnboardingPage(
            title: "Simple & Offline",
            subtitle: "Always Ready",
            description: "Simple, offline, and ready to help — your home leisure assistant. No internet connection required, everything works locally on your device.",
            systemImage: "wifi.slash"
        )
    ]
    
    var body: some View {
        return ZStack {
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
                
                VStack(spacing: 30) {
                    HStack(spacing: 12) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.primaryOrange : AppColors.primaryWhite.opacity(0.3))
                                .frame(width: 12, height: 12)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    HStack(spacing: 20) {
                        if currentPage > 0 {
                            Button("Back") {
                                withAnimation {
                                    currentPage -= 1
                                }
                            }
                            .font(.theme.buttonMedium)
                            .foregroundColor(AppColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        Button {
                            if currentPage == pages.count - 1 {
                                print("Get Started button tapped - completing onboarding")
                                isOnboardingComplete = true
                                appViewModel.completeOnboarding()
                            } else {
                                withAnimation {
                                    currentPage += 1
                                }
                            }
                        } label: {
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                                .font(.theme.buttonLarge)
                                .foregroundColor(AppColors.textPrimary)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 15)
                                .background(AppColors.primaryOrange)
                                .cornerRadius(25)
                                .shadow(color: AppColors.primaryOrange.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let description: String
    let systemImage: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.primaryWhite.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: page.systemImage)
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(AppColors.primaryOrange)
            }
            
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text(page.title)
                        .font(.theme.largeTitle)
                        .foregroundColor(AppColors.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text(page.subtitle)
                        .font(.theme.title2)
                        .foregroundColor(AppColors.primaryOrange)
                        .multilineTextAlignment(.center)
                }
                
                Text(page.description)
                    .font(.theme.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}
