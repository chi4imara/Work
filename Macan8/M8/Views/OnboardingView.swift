import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appState: AppStateViewModel
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    let pages = [
        OnboardingPage(
            title: "Collect your nail art dreams",
            description: "Save every color, pattern, and idea that inspires you. Create seasonal or event-based collections — from bright summer looks to elegant wedding designs.",
            systemImage: "paintbrush.pointed.fill"
        ),
        OnboardingPage(
            title: "Organize Your Ideas",
            description: "Mark which ideas you've tried, which you love, and which you're planning next. Your personal nail inspiration gallery — always at hand, always organized.",
            systemImage: "folder.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index], isAnimating: $isAnimating)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                VStack(spacing: 30) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.accentYellow : AppColors.primaryText.opacity(0.3))
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
                            appState.completeOnboarding()
                        }
                    }) {
                        Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                            .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                            .foregroundColor(AppColors.primaryBlue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(AppColors.accentYellow)
                            .cornerRadius(28)
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            isAnimating = true
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
    @Binding var isAnimating: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.systemImage)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.accentYellow)
                .scaleEffect(isAnimating ? 1.0 : 0.5)
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.8).delay(0.2), value: isAnimating)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(FontManager.playfairDisplay(size: 32, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: isAnimating)
                
                Text(page.description)
                    .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: isAnimating)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(appState: AppStateViewModel())
}
