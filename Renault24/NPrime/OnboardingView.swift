import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            title: "Achieve Your Goals",
            description: "Plan workouts, track nutrition and monitor your progress.",
            icon: "target"
        ),
        OnboardingPage(
            title: "Small Steps - Big Results",
            description: "Create plans, complete mini-challenges and track improvements.",
            icon: "chart.line.uptrend.xyaxis"
        ),
        OnboardingPage(
            title: "Start Today",
            description: "Daily tasks, visual rewards and micro-support will help you stay in shape.",
            icon: "bolt.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.orange : AppColors.textSecondary.opacity(0.3))
                            .frame(width: 8, height: 8)
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
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 16) {
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage += 1
                            }
                        } else {
                            appState.completeOnboarding()
                        }
                    }) {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .frame(maxWidth: .infinity)
                            .primaryButtonStyle()
                    }
                    
                    if currentPage < pages.count - 1 {
                        Button(action: {
                            appState.completeOnboarding()
                        }) {
                            Text("Skip")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.textSecondary)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var animateIcon = false
    @State private var animateText = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardBackground)
                    .frame(width: 120, height: 120)
                    .scaleEffect(animateIcon ? 1.1 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true),
                        value: animateIcon
                    )
                
                Image(systemName: page.icon)
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(Color.orange)
            }
            .onAppear {
                animateIcon = true
            }
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.ubuntu(32, weight: .bold))
                    .foregroundColor(AppColors.text)
                    .multilineTextAlignment(.center)
                    .opacity(animateText ? 1.0 : 0.0)
                    .offset(y: animateText ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: animateText)
                
                Text(page.description)
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .opacity(animateText ? 1.0 : 0.0)
                    .offset(y: animateText ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: animateText)
            }
            .padding(.horizontal, 32)
            .onAppear {
                withAnimation {
                    animateText = true
                }
            }
            
            Spacer()
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let icon: String
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
}
