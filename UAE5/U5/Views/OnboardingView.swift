import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            ColorManager.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPage(
                        imageName: "figure.strengthtraining.traditional",
                        title: "Build Your Home Workout Log",
                        description: "Create your own training routines with bodyweight exercises and track the days you complete them. Each workout stores its exercises, reps, and details so you can easily repeat your sets and keep a clean record of your training history at home.",
                        pageIndex: 0
                    )
                    .tag(0)
                    
                    OnboardingPage(
                        imageName: "calendar.badge.checkmark",
                        title: "Track Your Progress",
                        description: "Mark completed workouts and view your training history. See which days you exercised and maintain consistency in your fitness journey.",
                        pageIndex: 1
                    )
                    .tag(1)
                    
                    OnboardingPage(
                        imageName: "chart.line.uptrend.xyaxis",
                        title: "Stay Motivated",
                        description: "Monitor your exercise frequency and build healthy habits. Your workout calendar will show your dedication and progress over time.",
                        pageIndex: 2
                    )
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(currentPage == index ? ColorManager.accentOrange : ColorManager.primaryText.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 30)
                
                Button(action: {
                    if currentPage < 2 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    } else {
                        hasSeenOnboarding = true
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showOnboarding = false
                        }
                    }
                }) {
                    Text(currentPage < 2 ? "Continue" : "Get Started")
                        .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                        .foregroundColor(ColorManager.primaryText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(ColorManager.accentGradient)
                        .cornerRadius(25)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage: View {
    let imageName: String
    let title: String
    let description: String
    let pageIndex: Int
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorManager.accentBlue)
                .padding(.top, 60)
            
            VStack(spacing: 20) {
                Text(title)
                    .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Text(description)
                    .font(FontManager.playfairDisplay(size: 13, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
