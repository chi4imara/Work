import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppStateViewModel
    @State private var currentPage = 0
    
    let pages = [
        OnboardingPage(
            title: "A gentle space just for you.",
            description: "A place where you can slow down, write your thoughts, track your mood, and take care of yourself — one day at a time.",
            imageName: "heart.circle.fill"
        ),
        OnboardingPage(
            title: "How are you feeling today?",
            description: "Answer small questions, save meaningful moments, and notice patterns in your emotions.",
            imageName: "face.smiling.inverse"
        ),
        OnboardingPage(
            title: "Let's begin together.",
            description: "No pressure. Just honesty, calm, and a few minutes for yourself.",
            imageName: "hands.sparkles.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            GridBackgroundView()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                VStack(spacing: 30) {
                    HStack(spacing: 12) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? ColorTheme.primaryYellow : ColorTheme.gridBlue)
                                .frame(width: 12, height: 12)
                                .scaleEffect(index == currentPage ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentPage += 1
                            }
                        } else {
                            appState.completeOnboarding()
                        }
                    }) {
                        Text(currentPage == pages.count - 1 ? "Continue" : "Next")
                            .font(.ubuntuHeadline())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(ColorTheme.primaryBlue)
                            .cornerRadius(28)
                    }
                    .padding(.horizontal, 40)
                    
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            appState.completeOnboarding()
                        }
                        .font(.ubuntuBody())
                        .foregroundColor(ColorTheme.accentText)
                    }
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
                .foregroundColor(ColorTheme.primaryYellow)
                .padding(.bottom, 20)
            
            Text(page.title)
                .font(.ubuntuTitle())
                .foregroundColor(ColorTheme.primaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Text(page.description)
                .font(.ubuntuBody())
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
}
