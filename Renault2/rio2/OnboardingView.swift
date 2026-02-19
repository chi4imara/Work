import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentPage = 0
    @State private var animateContent = false
    
    private let pages = [
        OnboardingPage(
            title: "Bloom with Your Style",
            description: "Organize your wardrobe, create outfits and get style recommendations.",
            icon: "tshirt.fill",
            accentColor: AppColors.pink
        ),
        OnboardingPage(
            title: "Small Steps - Perfect Look",
            description: "Create combinations, participate in mini-challenges and track your style every day.",
            icon: "star.fill",
            accentColor: AppColors.purple
        ),
        OnboardingPage(
            title: "Let's Start Together",
            description: "Daily tasks, visual rewards and micro-support will help you feel confident.",
            icon: "heart.fill",
            accentColor: AppColors.green
        )
    ]
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Capsule()
                            .fill(index <= currentPage ? AppColors.yellow : AppColors.primaryText.opacity(0.3))
                            .frame(width: index == currentPage ? 30 : 10, height: 6)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.top, 60)
                .padding(.bottom, 40)
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index], isActive: currentPage == index)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .onChange(of: currentPage) { _ in
                    withAnimation(.easeInOut(duration: 0.5)) {
                        animateContent.toggle()
                    }
                }
                
                VStack(spacing: 20) {
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentPage += 1
                            }
                        } else {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                appState.hasCompletedOnboarding = true
                                appState.persistOnboardingState()
                            }
                        }
                    }) {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(AppColors.accentText)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                            .background(AppColors.yellow)
                            .cornerRadius(25)
                    }
                    
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                appState.hasCompletedOnboarding = true
                                appState.persistOnboardingState()
                            }
                        }
                        .font(.ubuntu(16))
                        .foregroundColor(AppColors.secondaryText)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            animateContent = true
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let icon: String
    let accentColor: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let isActive: Bool
    @State private var iconScale: CGFloat = 0.8
    @State private var textOpacity: Double = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(page.accentColor.opacity(0.2))
                    .frame(width: 160, height: 160)
                    .scaleEffect(isActive ? 1 : 0.8)
                
                Circle()
                    .fill(page.accentColor.opacity(0.4))
                    .frame(width: 120, height: 120)
                    .scaleEffect(isActive ? 1 : 0.8)
                
                Image(systemName: page.icon)
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                    .scaleEffect(iconScale)
            }
            .animation(.spring(response: 0.8, dampingFraction: 0.6), value: isActive)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .opacity(textOpacity)
                
                Text(page.description)
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .opacity(textOpacity)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .onChange(of: isActive) { active in
            if active {
                withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                    iconScale = 1.0
                }
                withAnimation(.easeOut(duration: 0.8).delay(0.4)) {
                    textOpacity = 1.0
                }
            } else {
                iconScale = 0.8
                textOpacity = 0.6
            }
        }
        .onAppear {
            if isActive {
                withAnimation(.easeOut(duration: 0.6)) {
                    iconScale = 1.0
                }
                withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                    textOpacity = 1.0
                }
            }
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
}
