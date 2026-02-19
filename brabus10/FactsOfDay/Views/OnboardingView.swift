import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    private let totalPages = 4
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPage(
                        systemImage: "clock.fill",
                        title: "A quiet timeline of your day.",
                        description: "This app captures everyday moments as simple facts: a coffee, a walk, a meeting. You add short events as they happen and see your day unfold as a clean timeline.",
                        isLastPage: false,
                        onContinue: { currentPage = 1 }
                    )
                    .tag(0)
                    
                    OnboardingPage(
                        systemImage: "calendar.badge.clock",
                        title: "Track Your Moments",
                        description: "Every event is automatically timestamped. Browse through your calendar to see what happened on any day. Your timeline grows organically as you record life's simple moments.",
                        isLastPage: false,
                        onContinue: { currentPage = 2 }
                    )
                    .tag(1)
                    
                    OnboardingPage(
                        systemImage: "chart.bar.fill",
                        title: "Review Your Journey",
                        description: "Access your complete archive of events and view statistics about your daily activities. See patterns emerge from the simple facts you've recorded over time.",
                        isLastPage: false,
                        onContinue: { currentPage = 3 }
                    )
                    .tag(2)
                    
                    OnboardingPage(
                        systemImage: "list.bullet.clipboard.fill",
                        title: "Simple. Clean. Organized.",
                        description: "No analysis, no summaries, just a clear record of what actually took place, one moment after another. Your personal timeline of daily facts.",
                        isLastPage: true,
                        onContinue: {
                            withAnimation(.easeOut(duration: 0.5)) {
                                showOnboarding = true
                                UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                            }
                        }
                    )
                    .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                PageIndicator(currentPage: currentPage, totalPages: totalPages)
                    .padding(.bottom, 30)
            }
        }
    }
}

struct OnboardingPage: View {
    let systemImage: String
    let title: String
    let description: String
    let isLastPage: Bool
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: systemImage)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorTheme.primaryBlue)
                .padding(.bottom, 20)
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.custom("PlayfairDisplay-Bold", size: 28))
                    .foregroundColor(ColorTheme.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Text(description)
                    .font(.custom("PlayfairDisplay-Regular", size: 16))
                    .foregroundColor(ColorTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            
            Button(action: onContinue) {
                HStack {
                    Text(isLastPage ? "Get Started" : "Continue")
                        .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                        .foregroundColor(.white)
                    
                    if !isLastPage {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    LinearGradient(
                        colors: [ColorTheme.primaryBlue, ColorTheme.accentYellow],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(28)
                .shadow(color: ColorTheme.shadowColor, radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
    }
}

struct PageIndicator: View {
    let currentPage: Int
    let totalPages: Int
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<totalPages, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage ? ColorTheme.primaryBlue : ColorTheme.textSecondary.opacity(0.3))
                    .frame(width: index == currentPage ? 24 : 8, height: 8)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
            }
        }
    }
}
