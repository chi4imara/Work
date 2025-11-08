import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboardingComplete: Bool
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            title: "Collect Your Memories",
            description: "Build your own archive of important life moments. Write short notes about the events that matter — a new job, a special meeting, a trip, or a happy day at home.",
            systemImage: "book.fill"
        ),
        OnboardingPage(
            title: "Organize & Review",
            description: "Your collection grows into a diary you can revisit anytime: a list for quick browsing, a calendar to see when things happened, and summaries that highlight your most meaningful memories.",
            systemImage: "calendar"
        ),
        OnboardingPage(
            title: "Simple & Personal",
            description: "Simple, personal, timeless — your story, one note at a time. Start building your memory collection today.",
            systemImage: "heart.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            BackgroundView()
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
                
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? AppColors.primaryYellow : AppColors.primaryWhite.opacity(0.3))
                            .frame(width: 10, height: 10)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                .padding(.bottom, 40)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        UserDefaults.standard.set(true, forKey: "OnboardingComplete")
                        UserDefaults.standard.synchronize()
                        print("OnboardingView: Saving onboarding completion")
                        isOnboardingComplete = true
                    }
                }) {
                    Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                        .font(AppFonts.buttonLarge)
                        .foregroundColor(AppColors.buttonText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppColors.buttonBackground)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 32)
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
                .foregroundColor(AppColors.primaryYellow)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(AppFonts.largeTitle)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(isOnboardingComplete: .constant(false))
}
