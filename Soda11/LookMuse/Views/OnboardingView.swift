import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: OutfitViewModel
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    private let pages = [
        OnboardingPage(
            title: "Your style, your story.",
            description: "Turn your everyday looks into your personal style archive.",
            imageName: "tshirt.fill"
        ),
        OnboardingPage(
            title: "Track Every Detail",
            description: "Write down what you wore, when, and where — along with weather notes or small memories from that day.",
            imageName: "calendar"
        ),
        OnboardingPage(
            title: "Seasonal Gallery",
            description: "The app builds your outfit gallery by season, helping you see what truly works for you and what combinations you love most.",
            imageName: "leaf.fill"
        ),
        OnboardingPage(
            title: "Personal Style Space",
            description: "A simple, private space to reflect on your outfits and rediscover your personal style anytime.",
            imageName: "heart.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index], isAnimating: isAnimating)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                VStack(spacing: 20) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.theme.primaryYellow : Color.theme.primaryWhite.opacity(0.4))
                                .frame(width: 8, height: 8)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                        }
                    }
                    .padding(.bottom, 10)
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentPage += 1
                            }
                        } else {
                            viewModel.completeOnboarding()
                        }
                    }) {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(Color.theme.buttonText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.theme.buttonBackground)
                                    .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
                            )
                    }
                    .padding(.horizontal, 40)
                    
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            viewModel.completeOnboarding()
                        }
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(Color.theme.secondaryText)
                        .padding(.top, 10)
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                isAnimating = true
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
    let isAnimating: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(Color.theme.primaryYellow)
                .scaleEffect(isAnimating ? 1.0 : 0.5)
                .opacity(isAnimating ? 1.0 : 0.3)
                .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2), value: isAnimating)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: isAnimating)
                
                Text(page.description)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 30)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: isAnimating)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    OnboardingView(viewModel: OutfitViewModel())
}
