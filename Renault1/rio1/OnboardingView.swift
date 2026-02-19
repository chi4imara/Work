import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            title: "Take Care of Yourself Every Day",
            subtitle: "Track your mood, capture thoughts, and create mini-rituals for emotional wellness",
            imageName: "heart.fill",
            color: AppColors.primary
        ),
        OnboardingPage(
            title: "Small Steps - Harmony and Peace",
            subtitle: "Build habits, participate in mini-challenges, and track your progress",
            imageName: "leaf.fill",
            color: AppColors.secondary
        ),
        OnboardingPage(
            title: "Let's Start Together",
            subtitle: "Daily tasks, visual rewards, and micro-support will help you feel better every day",
            imageName: "sparkles",
            color: AppColors.accent
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Capsule()
                            .fill(index <= currentPage ? AppColors.primary : AppColors.lightGray)
                            .frame(width: index == currentPage ? 40 : 12, height: 6)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: currentPage)
                    }
                }
                .padding(.top, 60)
                .padding(.horizontal)
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            withAnimation(.spring()) {
                                if value.translation.width < -50 && currentPage < pages.count - 1 {
                                    currentPage += 1
                                } else if value.translation.width > 50 && currentPage > 0 {
                                    currentPage -= 1
                                }
                            }
                        }
                )
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            currentPage += 1
                        }
                    } else {
                        appState.completeOnboarding()
                    }
                }) {
                    HStack {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        if currentPage < pages.count - 1 {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [AppColors.primary, AppColors.accent],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(25)
                    .shadow(color: AppColors.primary.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
                
                if currentPage < pages.count - 1 {
                    Button("Skip") {
                        appState.completeOnboarding()
                    }
                    .font(FontManager.playfairDisplay(size: 16))
                    .foregroundColor(AppColors.primary.opacity(0.7))
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let imageName: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var isAnimated = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.1))
                    .frame(width: 160, height: 160)
                    .scaleEffect(isAnimated ? 1.0 : 0.8)
                    .opacity(isAnimated ? 1.0 : 0.6)
                
                Image(systemName: page.imageName)
                    .font(.system(size: 60, weight: .medium))
                    .foregroundColor(page.color)
                    .scaleEffect(isAnimated ? 1.0 : 0.7)
            }
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2)) {
                    isAnimated = true
                }
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(AppColors.text)
                    .padding(.horizontal, 20)
                
                Text(page.subtitle)
                    .font(FontManager.playfairDisplay(size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(AppColors.text.opacity(0.7))
                    .padding(.horizontal, 40)
                    .lineSpacing(4)
            }
            
            Spacer()
        }
        .opacity(isAnimated ? 1.0 : 0.0)
        .offset(y: isAnimated ? 0 : 20)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.1)) {
                isAnimated = true
            }
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
}
