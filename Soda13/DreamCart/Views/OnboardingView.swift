import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: BeautyDiaryViewModel
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            title: "Your beauty habits, beautifully organized.",
            description: "Keep a simple record of your beauty routine.",
            imageName: "sparkles"
        ),
        OnboardingPage(
            title: "Track Your Products",
            description: "Write down which products or treatments you used each day — from serums and masks to hair care and makeup sessions.",
            imageName: "heart.fill"
        ),
        OnboardingPage(
            title: "Discover What Works",
            description: "Over time, you'll see which combinations bring the best visible results and which products work best together.\n\nA calm, personal space to track your beauty experiments and rediscover what truly suits you.",
            imageName: "star.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
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
                                .fill(currentPage == index ? Color.theme.primaryBlue : Color.theme.lightGray)
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut, value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            viewModel.completeOnboarding()
                        }
                    }) {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(Color.theme.buttonText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.theme.buttonBackground)
                            .cornerRadius(25)
                    }
                    .padding(.horizontal, 40)
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
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.system(size: 80))
                .foregroundColor(Color.theme.primaryPurple)
                .padding(.bottom, 20)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.playfairDisplay(28, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Text(page.description)
                    .font(.playfairDisplay(16))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(viewModel: BeautyDiaryViewModel())
}
