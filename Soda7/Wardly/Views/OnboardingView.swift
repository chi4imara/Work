import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appState: AppStateViewModel
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    private let pages = [
        OnboardingPage(
            title: "Plan your wardrobe wisely",
            description: "Turn every clothing purchase into a thoughtful choice. This app helps you plan what to buy, set priorities, and see what truly matters by the end of the month.",
            imageName: "wardrobe"
        ),
        OnboardingPage(
            title: "Track your priorities",
            description: "Add items to your wish list, estimate their cost, and track which ones you actually purchase. Set priorities to distinguish needs from wants.",
            imageName: "priorities"
        ),
        OnboardingPage(
            title: "Learn from your choices",
            description: "With a clear overview of your wardrobe goals, you'll learn which buys become essentials — and which were just impulses. Simple, structured, and made for mindful shoppers.",
            imageName: "insights"
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(
                            page: pages[index],
                            isAnimating: isAnimating
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 30) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.primaryPurple : AppColors.neutralGray.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    VStack(spacing: 16) {
                        if currentPage < pages.count - 1 {
                            Button(action: nextPage) {
                                Text("Continue")
                                    .font(AppTypography.buttonText)
                                    .primaryButtonStyle()
                            }
                            
                            Button(action: completeOnboarding) {
                                Text("Skip")
                                    .font(AppTypography.callout)
                                    .foregroundColor(AppColors.neutralGray)
                            }
                        } else {
                            Button(action: completeOnboarding) {
                                Text("Get Started")
                                    .font(AppTypography.buttonText)
                                    .primaryButtonStyle()
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                isAnimating = true
            }
        }
    }
    
    private func nextPage() {
        withAnimation(.easeInOut(duration: 0.5)) {
            currentPage += 1
        }
    }
    
    private func completeOnboarding() {
        withAnimation(.easeInOut(duration: 0.5)) {
            appState.completeOnboarding()
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
    let isAnimating: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.lightPurple.opacity(0.3))
                    .frame(width: 180, height: 180)
                    .scaleEffect(isAnimating ? 1.0 : 0.8)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: isAnimating)
                
                Circle()
                    .fill(AppColors.purpleGradient)
                    .frame(width: 110, height: 110)
                    .scaleEffect(isAnimating ? 1.0 : 0.6)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: isAnimating)
                
                Image(systemName: getIconName(for: page.imageName))
                    .font(.system(size: 35, weight: .light))
                    .foregroundColor(.white)
                    .scaleEffect(isAnimating ? 1.0 : 0.4)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: isAnimating)
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(FontManager.playfairBold(size: 23))
                    .foregroundColor(AppColors.primaryPurple)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.8), value: isAnimating)
                
                Text(page.description)
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.darkGray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(1.0), value: isAnimating)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private func getIconName(for imageName: String) -> String {
        switch imageName {
        case "wardrobe":
            return "tshirt"
        case "priorities":
            return "star.circle"
        case "insights":
            return "chart.bar"
        default:
            return "heart"
        }
    }
}

#Preview {
    OnboardingView(appState: AppStateViewModel())
}
