import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appViewModel: AppViewModel
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            title: "Choose your scent with confidence.",
            description: "Build a personal archive of your favorite fragrances with notes, seasons, and usage styles.",
            imageName: "sparkles"
        ),
        OnboardingPage(
            title: "Organize & Discover",
            description: "Quickly recall what you own, explore your collection in a clear way, and select the right scent for any occasion without overthinking.",
            imageName: "archivebox"
        ),
        OnboardingPage(
            title: "Stay Simple & Ready",
            description: "Everything stays simple, organized, and ready when you need it. Your perfect fragrance is just a tap away.",
            imageName: "checkmark.circle"
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
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
                            .fill(currentPage == index ? AppColors.primaryWhite : AppColors.primaryWhite.opacity(0.4))
                            .frame(width: 8, height: 8)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 40)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    } else {
                        appViewModel.completeOnboarding()
                    }
                }) {
                    Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                        .font(.lumierepolis(18, weight: .bold))
                        .foregroundColor(AppColors.primaryWhite)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(AppColors.buttonPrimary)
                        .cornerRadius(28)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
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
                .foregroundColor(AppColors.primaryWhite)
                .padding(.bottom, 20)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.lumierepolis(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                Text(page.description)
                    .font(.lumierepolis(16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 32)
            }
            
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
    OnboardingView(appViewModel: AppViewModel())
}
