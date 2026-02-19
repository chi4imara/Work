import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appState: AppStateViewModel
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    private let pages = [
        OnboardingPage(
            title: "Capture what resonates with you",
            description: "Save quick reactions to movies, food, places, people, and everyday moments.",
            imageName: "heart.text.square.fill",
            color: AppColors.primaryBlue
        ),
        OnboardingPage(
            title: "Build your personal archive",
            description: "This app helps you capture impressions as they happen and build a personal archive of what stands out to you.",
            imageName: "square.stack.3d.up.fill",
            color: AppColors.accentOrange
        ),
        OnboardingPage(
            title: "Discover your patterns",
            description: "Over time, you see patterns in your choices and make decisions faster based on what truly resonates.",
            imageName: "chart.bar.fill",
            color: AppColors.accentPurple
        )
    ]
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index], isAnimating: isAnimating)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                VStack(spacing: 24) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.primaryBlue : AppColors.textSecondary.opacity(0.3))
                                .frame(width: 8, height: 8)
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
                            withAnimation(.easeInOut(duration: 0.5)) {
                                appState.completeOnboarding()
                            }
                        }
                    }) {
                        HStack {
                            Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                                .font(.ibmPlexMono(16, weight: .semibold))
                                .foregroundColor(.white)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(AppColors.buttonGradient)
                        .cornerRadius(25)
                        .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 32)
                    
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                appState.completeOnboarding()
                            }
                        }
                        .font(.ibmPlexMono(14, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                    }
                }
                .padding(.bottom, 50)
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
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let isAnimating: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.1))
                    .frame(width: 160, height: 160)
                    .scaleEffect(isAnimating ? 1.0 : 0.8)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: isAnimating)
                
                Image(systemName: page.imageName)
                    .font(.system(size: 60, weight: .medium))
                    .foregroundColor(page.color)
                    .scaleEffect(isAnimating ? 1.0 : 0.5)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: isAnimating)
            }
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.ibmPlexMono(24, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: isAnimating)
                
                Text(page.description)
                    .font(.ibmPlexMono(16, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.8), value: isAnimating)
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
    }
}
