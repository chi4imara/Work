import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var currentPage = 0
    @State private var showMainApp = false
    
    private let pages = [
        OnboardingPage(
            title: "Random Fun Challenges for Friends",
            description: "This app makes any hangout more exciting with random challenges. Spin it and get a task: tell a joke, sing a line, or take a funny photo.",
            imageName: "person.3.fill"
        ),
        OnboardingPage(
            title: "Simple, Social, Spontaneous",
            description: "Each challenge is quick, fun, and made to keep everyone laughing. Simple, social, and spontaneous fun for any occasion.",
            imageName: "heart.fill"
        ),
        OnboardingPage(
            title: "Ready to Start?",
            description: "Create your own challenges, organize them by categories, and keep track of your favorites. Let's make every moment memorable!",
            imageName: "star.fill"
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
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 20) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.primary : AppColors.primary.opacity(0.3))
                                .frame(width: 10, height: 10)
                                .animation(.easeInOut, value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage += 1
                            }
                        } else {
                            dataManager.completeOnboarding()
                            showMainApp = true
                        }
                    }) {
                        HStack {
                            Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(.white)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            LinearGradient(
                                colors: [AppColors.primary, AppColors.secondary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(25)
                        .shadow(color: AppColors.primary.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 30)
                    
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            dataManager.completeOnboarding()
                            showMainApp = true
                        }
                        .font(.ubuntu(16))
                        .foregroundColor(AppColors.textSecondary)
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .fullScreenCover(isPresented: $showMainApp) {
            MainTabView()
                .environmentObject(dataManager)
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primary)
                .shadow(color: AppColors.primary.opacity(0.3), radius: 10, x: 0, y: 5)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Text(page.description)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            Spacer()
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}

#Preview {
    OnboardingView()
        .environmentObject(DataManager.shared)
}
