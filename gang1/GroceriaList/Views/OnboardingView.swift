import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appViewModel: AppViewModel
    @State private var currentPage = 0
    @State private var animateElements = false
    
    let pages = [
        OnboardingPage(
            title: "Plan smarter, shop faster.",
            description: "This app helps you create and manage your shopping list in seconds. Just add what you need — bread, milk, coffee — and check items off as you buy them.",
            imageName: "cart.fill"
        ),
        OnboardingPage(
            title: "Stay organized",
            description: "The clean layout keeps everything visible, so you always know what's done and what's left. No distractions, no complexity — only what matters for your next shopping trip.",
            imageName: "list.bullet.clipboard.fill"
        ),
        OnboardingPage(
            title: "Simple and satisfying",
            description: "Each checked item gives you a small sense of progress and clarity. Stay organized, save time, and make your shopping simple and satisfying.",
            imageName: "checkmark.circle.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    ColorManager.backgroundGradientStart,
                    ColorManager.backgroundGradientEnd
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ForEach(0..<5, id: \.self) { index in
                Circle()
                    .fill(ColorManager.orbColors[index % ColorManager.orbColors.count])
                    .frame(width: CGFloat.random(in: 30...80))
                    .position(
                        x: CGFloat.random(in: 50...(UIScreen.main.bounds.width - 50)),
                        y: CGFloat.random(in: 100...(UIScreen.main.bounds.height - 200))
                    )
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 3...6))
                            .repeatForever(autoreverses: true),
                        value: animateElements
                    )
            }
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(maxHeight: .infinity)
                
                VStack(spacing: 30) {
                    HStack(spacing: 12) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? ColorManager.primaryYellow : ColorManager.primaryWhite.opacity(0.4))
                                .frame(width: 12, height: 12)
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
                            appViewModel.completeOnboarding()
                        }
                    }) {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(FontManager.ubuntuMedium(18))
                            .foregroundColor(ColorManager.primaryBlue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .concaveCard(cornerRadius: 28, depth: 4, color: ColorManager.primaryYellow)
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            animateElements = true
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
    @State private var animateContent = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorManager.primaryYellow)
                .scaleEffect(animateContent ? 1.0 : 0.5)
                .opacity(animateContent ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(FontManager.ubuntuBold(32))
                    .foregroundColor(ColorManager.primaryText)
                    .multilineTextAlignment(.center)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent)
                
                Text(page.description)
                    .font(FontManager.ubuntu(18))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 30)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: animateContent)
            }
            
            Spacer()
        }
        .onAppear {
            animateContent = true
        }
        .onDisappear {
            animateContent = false
        }
    }
}

#Preview {
    OnboardingView(appViewModel: AppViewModel())
}
