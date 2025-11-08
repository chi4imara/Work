import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    var onComplete: () -> Void
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPageView(
                        icon: "dice.fill",
                        title: "Board Game Log",
                        subtitle: "Track Plays & Wins",
                        description: "Keep a clean record of your board game collection. Add games with player counts and play time."
                    )
                    .tag(0)
                    
                    OnboardingPageView(
                        icon: "person.3.fill",
                        title: "Log Sessions",
                        subtitle: "Players & Winners",
                        description: "Log each session with players, winners, and notes. See who's on a winning streak."
                    )
                    .tag(1)
                    
                    OnboardingPageView(
                        icon: "chart.bar.fill",
                        title: "View Statistics",
                        subtitle: "Clear Lists & Stats",
                        description: "Clear lists, fast entry, and helpful stats — your table memories, organized."
                    )
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                Button(action: {
                    if currentPage < 2 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        onComplete()
                    }
                }) {
                    Text(currentPage == 2 ? "Get Started" : "Continue")
                        .font(AppFonts.semiBold(size: 18))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [AppColors.primaryBlue, AppColors.secondaryBlue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
    }
}

struct OnboardingPageView: View {
    let icon: String
    let title: String
    let subtitle: String
    let description: String
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [AppColors.lightBlue.opacity(0.3), AppColors.primaryBlue.opacity(0.1)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                
                Image(systemName: icon)
                    .font(.system(size: 70, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [AppColors.primaryBlue, AppColors.secondaryBlue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .padding(.bottom, 20)
            
            VStack(spacing: 12) {
                Text(title)
                    .font(AppFonts.bold(size: 32))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(AppFonts.semiBold(size: 20))
                    .foregroundColor(AppColors.primaryBlue)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(AppFonts.regular(size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 8)
            }
            
            Spacer()
            Spacer()
        }
    }
}

