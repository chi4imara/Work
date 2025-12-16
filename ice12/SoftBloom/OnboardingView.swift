import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: GratitudeViewModel
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    private let pages = [
        OnboardingPage(
            title: "Build Your Gratitude",
            subtitle: "One Day at a Time",
            description: "This app is a simple daily gratitude calendar. Every day, write one thing you're grateful for and watch your streak grow.",
            imageName: "heart.circle.fill"
        ),
        OnboardingPage(
            title: "Track Your Journey",
            subtitle: "See Your Progress",
            description: "Browse your monthly view, revisit past entries, and keep a clear, motivating record of positive moments.",
            imageName: "calendar.circle.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index], isAnimating: isAnimating)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                HStack(spacing: 12) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.accentYellow : Color.lightGray)
                            .frame(width: 12, height: 12)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentPage)
                    }
                }
                .padding(.bottom, 40)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            currentPage += 1
                        }
                    } else {
                        viewModel.completeOnboarding()
                    }
                }) {
                    HStack {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(.playfairDisplay(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        if currentPage < pages.count - 1 {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.purpleGradient)
                    .cornerRadius(12)
                    .shadow(color: Color.primaryPurple.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                isAnimating = true
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let description: String
    let imageName: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let isAnimating: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.accentBlue.opacity(0.1))
                    .frame(width: 160, height: 160)
                    .scaleEffect(isAnimating ? 1.0 : 0.8)
                    .opacity(isAnimating ? 1.0 : 0.0)
                
                Image(systemName: page.imageName)
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(.accentBlue)
                    .scaleEffect(isAnimating ? 1.0 : 0.5)
                    .opacity(isAnimating ? 1.0 : 0.0)
            }
            .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2), value: isAnimating)
            
            VStack(spacing: 8) {
                Text(page.title)
                    .font(.playfairDisplay(size: 32, weight: .bold))
                    .foregroundColor(.primaryPurple)
                    .multilineTextAlignment(.center)
                    .offset(y: isAnimating ? 0 : 30)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: isAnimating)
                
                Text(page.subtitle)
                    .font(.playfairDisplay(size: 24, weight: .medium))
                    .foregroundColor(.accentBlue)
                    .multilineTextAlignment(.center)
                    .offset(y: isAnimating ? 0 : 30)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: isAnimating)
                
                Text(page.description)
                    .font(.playfairDisplay(size: 13))
                    .foregroundColor(.darkGray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 20)
                    .offset(y: isAnimating ? 0 : 30)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.8).delay(0.8), value: isAnimating)
            }
            
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}
