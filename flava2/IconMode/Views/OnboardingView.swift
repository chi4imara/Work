import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    private let pages = [
        OnboardingPage(
            title: "Celebrate Your Small Wins",
            description: "This app helps you capture and celebrate even the smallest victories of your day. Every achievement matters — whether it's finishing a task, keeping a promise to yourself, or just doing something that made you feel good.",
            systemImage: "trophy.fill"
        ),
        OnboardingPage(
            title: "Keep Your Archive",
            description: "Write it down, keep your archive of wins, and revisit them whenever you need motivation. Your victories are saved by days, shown in a calendar and history.",
            systemImage: "calendar"
        ),
        OnboardingPage(
            title: "Track Your Progress",
            description: "You can mark your favorites, track how often you succeed, and watch your positive moments grow over time. It's a daily reminder that progress isn't only about big milestones. Sometimes, the little wins matter the most.",
            systemImage: "chart.line.uptrend.xyaxis"
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GridBackgroundView()
                .opacity(0.2)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index], isAnimating: isAnimating)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                VStack(spacing: 20) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Rectangle()
                                .fill(currentPage == index ? AppColors.primary : AppColors.primary.opacity(0.3))
                                .frame(width: currentPage == index ? 24 : 8, height: 8)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentPage += 1
                            }
                        } else {
                            showOnboarding = false
                        }
                    }) {
                        HStack {
                            Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                                .font(AppFonts.pixelButton)
                                .foregroundColor(AppColors.textLight)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(AppColors.textLight)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppColors.buttonGradient)
                        .cornerRadius(0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 0)
                                .stroke(AppColors.primary, lineWidth: 2)
                        )
                    }
                    .padding(.horizontal, 32)
                    .scaleEffect(isAnimating ? 1.0 : 0.9)
                    
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            showOnboarding = false
                        }
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.textSecondary)
                        .padding(.bottom, 20)
                    } else {
                        Spacer()
                            .frame(height: 44)
                    }
                }
                .padding(.bottom, 20)
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
    let systemImage: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let isAnimating: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 120, height: 120)
                    .overlay(
                        Circle()
                            .stroke(AppColors.primary, lineWidth: 3)
                    )
                
                Image(systemName: page.systemImage)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(AppColors.primary)
            }
            .scaleEffect(isAnimating ? 1.0 : 0.8)
            .opacity(isAnimating ? 1.0 : 0.5)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(AppFonts.title1)
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1.0 : 0.0)
                
                Text(page.description)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .opacity(isAnimating ? 1.0 : 0.0)
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
        .animation(.easeInOut(duration: 1.0).delay(0.3), value: isAnimating)
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
