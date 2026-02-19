import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appViewModel: AppViewModel
    @State private var currentPage = 0
    @State private var offset: CGFloat = 0
    
    let pages = [
        OnboardingPage(
            title: "Start your day with energy",
            description: "Track your motivation level and perform short rituals for confidence every day.",
            systemImage: "sunrise.fill",
            color: ColorManager.primaryYellow
        ),
        OnboardingPage(
            title: "Small habits — big results",
            description: "Add mini-challenges and habits to feel growth in confidence and energy.",
            systemImage: "target",
            color: ColorManager.primaryBlue
        ),
        OnboardingPage(
            title: "This space is for you",
            description: "Daily tasks, visual rewards and micro-support are waiting for you.",
            systemImage: "heart.fill",
            color: ColorManager.success
        )
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ColorManager.backgroundGradient
                    .ignoresSafeArea()
                
                VStack {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Capsule()
                                .fill(index <= currentPage ? ColorManager.primaryBlue : ColorManager.lightGray)
                                .frame(width: index == currentPage ? 24 : 8, height: 8)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    .padding(.top, 60)
                    
                    TabView(selection: $currentPage) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            OnboardingPageView(page: pages[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .onChange(of: currentPage) { _ in
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                    }
                    
                    VStack(spacing: 16) {
                        Button(action: {
                            if currentPage < pages.count - 1 {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentPage += 1
                                }
                            } else {
                                appViewModel.completeOnboarding()
                            }
                        }) {
                            HStack {
                                Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                                    .font(FontManager.medium(size: 18))
                                    .foregroundColor(.white)
                                
                                if currentPage < pages.count - 1 {
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(ColorManager.buttonGradient)
                            .cornerRadius(28)
                            .shadow(color: ColorManager.primaryBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal, 32)
                        
                        if currentPage < pages.count - 1 {
                            Button("Skip") {
                                appViewModel.completeOnboarding()
                            }
                            .font(FontManager.regular(size: 16))
                            .foregroundColor(ColorManager.darkGray)
                        }
                    }
                    .padding(.bottom, 50)
                }
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let systemImage: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.1))
                    .frame(width: 200, height: 200)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                
                Circle()
                    .fill(page.color.opacity(0.2))
                    .frame(width: 160, height: 160)
                    .scaleEffect(isAnimating ? 0.9 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                
                Image(systemName: page.systemImage)
                    .font(.system(size: 60, weight: .medium))
                    .foregroundColor(page.color)
                    .scaleEffect(isAnimating ? 1.05 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 1.8)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
            }
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(FontManager.bold(size: 28))
                    .foregroundColor(ColorManager.darkGray)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(FontManager.regular(size: 18))
                    .foregroundColor(ColorManager.darkGray.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .padding(.horizontal, 32)
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    OnboardingView(appViewModel: AppViewModel())
}
