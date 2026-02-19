import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var currentPage = 0
    @State private var animateContent = false
    
    private let onboardingPages = [
        OnboardingPage(
            title: "Start Your Day with Harmony",
            description: "Track your mood, take care of yourself and create emotional balance every day."
        ),
        OnboardingPage(
            title: "Small Steps - Great Calm",
            description: "Meditations, breathing and mini-habits will help you gently track your progress."
        ),
        OnboardingPage(
            title: "This Space is for You",
            description: "Daily tasks, visual rewards and support without pressure."
        )
    ]
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    ForEach(0..<onboardingPages.count, id: \.self) { index in
                        Capsule()
                            .fill(index <= currentPage ? AppColors.primaryAccent : AppColors.primaryText.opacity(0.3))
                            .frame(width: index == currentPage ? 30 : 8, height: 8)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.top, 60)
                
                Spacer()
                
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingPages.count, id: \.self) { index in
                        OnboardingPageView(
                            page: onboardingPages[index],
                            isActive: currentPage == index
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                Spacer()
                
                Button(action: {
                    if currentPage < onboardingPages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage += 1
                        }
                    } else {
                        viewModel.completeOnboarding()
                    }
                }) {
                    HStack {
                        Text(currentPage == onboardingPages.count - 1 ? "Get Started" : "Continue")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(AppColors.accentText)
                        
                        if currentPage < onboardingPages.count - 1 {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppColors.accentText)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(AppColors.primaryAccent)
                    .cornerRadius(28)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            animateContent = true
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let isActive: Bool
    @State private var animateIcon = false
    
    var body: some View {
        VStack(spacing: 40) {
            ZStack {
                Circle()
                    .fill(AppColors.softGradient)
                    .frame(width: 120, height: 120)
                    .scaleEffect(animateIcon ? 1.1 : 1.0)
                    .opacity(animateIcon ? 0.8 : 0.6)
                
                Image(systemName: iconForPage())
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(AppColors.primaryText)
                    .scaleEffect(animateIcon ? 1.0 : 0.8)
            }
            .onAppear {
                if isActive {
                    withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                        animateIcon = true
                    }
                }
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .opacity(isActive ? 1.0 : 0.7)
                    .animation(.easeInOut(duration: 0.5), value: isActive)
                
                Text(page.description)
                    .font(.ubuntu(16, weight: .light))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .opacity(isActive ? 1.0 : 0.6)
                    .animation(.easeInOut(duration: 0.5), value: isActive)
            }
            .padding(.horizontal, 40)
        }
    }
    
    private func iconForPage() -> String {
        switch page.title {
        case "Start Your Day with Harmony":
            return "sun.max.fill"
        case "Small Steps - Great Calm":
            return "leaf.fill"
        default:
            return "heart.fill"
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
}

#Preview {
    OnboardingView(viewModel: AppViewModel())
}
