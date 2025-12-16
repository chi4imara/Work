import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var isOnboardingComplete: Bool
    
    let pages = [
        OnboardingPage(
            title: "Bring Fun to Every Gathering",
            description: "This app gives you a complete catalog of games for friends and parties. From quick word games to active challenges, you'll always find something to play.",
            imageName: "gamecontroller.fill"
        ),
        OnboardingPage(
            title: "Browse by Category",
            description: "Organize your games by type - active, word games, board games, and more. Find the perfect game for any occasion.",
            imageName: "list.bullet.rectangle"
        ),
        OnboardingPage(
            title: "Add Your Own Games",
            description: "Keep track of your favorite games and even add your own custom games to build the perfect collection for your gatherings.",
            imageName: "plus.circle.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            ColorManager.mainGradient
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
                            .fill(currentPage == index ? ColorManager.primaryBlue : ColorManager.primaryBlue.opacity(0.3))
                            .frame(width: 10, height: 10)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 40)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        isOnboardingComplete = true
                    }
                }) {
                    Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                        .font(FontManager.ubuntu(size: 18, weight: .medium))
                        .foregroundColor(ColorManager.whiteText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(ColorManager.primaryBlue)
                        )
                }
                .padding(.horizontal, 40)
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
                .foregroundColor(ColorManager.primaryBlue)
                .padding(.top, 60)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(FontManager.ubuntu(size: 28, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Text(page.description)
                    .font(FontManager.ubuntu(size: 16, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 40)
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
    OnboardingView(isOnboardingComplete: .constant(false))
}
