import SwiftUI

struct OnboardingView: View {
    @Binding var isShowingOnboarding: Bool
    @State private var currentPage = 0
    
    let onboardingPages = [
        OnboardingPage(
            title: "Achieve Goals Every Day",
            description: "Plan workouts, track nutrition and progress.",
            systemImage: "target"
        ),
        OnboardingPage(
            title: "Small Steps - Big Results",
            description: "Create plans, complete mini-challenges and track progress.",
            systemImage: "chart.line.uptrend.xyaxis"
        ),
        OnboardingPage(
            title: "Let's Start Together",
            description: "Daily tasks, visual rewards and micro-support will help you stay in shape.",
            systemImage: "hands.sparkles.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            ColorTheme.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingPages.count, id: \.self) { index in
                        OnboardingPageView(page: onboardingPages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                HStack(spacing: 12) {
                    ForEach(0..<onboardingPages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? ColorTheme.primaryAccent : ColorTheme.primaryAccent.opacity(0.3))
                            .frame(width: currentPage == index ? 12 : 8, height: currentPage == index ? 12 : 8)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.vertical, 30)
                
                Button(action: {
                    if currentPage < onboardingPages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage += 1
                        }
                    } else {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isShowingOnboarding = true
                            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                        }
                    }
                }) {
                    HStack {
                        Text(currentPage == onboardingPages.count - 1 ? "Get Started" : "Continue")
                            .font(FontManager.playfairSemiBold(size: 18))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(ColorTheme.primaryText)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(ColorTheme.accentGradient)
                    .cornerRadius(16)
                    .shadow(color: ColorTheme.primaryAccent.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -50 && currentPage < onboardingPages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage += 1
                        }
                    } else if value.translation.width > 50 && currentPage > 0 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage -= 1
                        }
                    }
                }
        )
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(ColorTheme.primaryAccent.opacity(0.1))
                    .frame(width: 160, height: 160)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                
                Circle()
                    .fill(ColorTheme.primaryAccent.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .scaleEffect(isAnimating ? 1.0 : 0.9)
                
                Image(systemName: page.systemImage)
                    .font(.system(size: 48, weight: .medium))
                    .foregroundColor(ColorTheme.primaryAccent)
                    .scaleEffect(isAnimating ? 1.0 : 0.8)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(FontManager.playfairBold(size: 32))
                    .foregroundColor(ColorTheme.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(FontManager.playfairRegular(size: 18))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .padding(.horizontal, 32)
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let systemImage: String
}

#Preview {
    OnboardingView(isShowingOnboarding: .constant(true))
}
