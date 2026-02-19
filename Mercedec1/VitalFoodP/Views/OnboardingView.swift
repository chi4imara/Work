import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentPage = 0
    @State private var animateElements = false
    
    let pages = [
        OnboardingPage(
            title: "Eat based on how you feel.",
            description: "Track your mood and energy levels, discover meals that fit your emotional state, and build healthy eating habits.",
            systemImage: "heart.fill"
        ),
        OnboardingPage(
            title: "Personalized meal plans.",
            description: "Create custom meal plans based on your preferences, dietary restrictions, and energy needs throughout the day.",
            systemImage: "calendar.badge.plus"
        ),
        OnboardingPage(
            title: "Track your energy.",
            description: "Monitor your energy levels and mood patterns to better understand how food affects your daily wellbeing.",
            systemImage: "chart.line.uptrend.xyaxis"
        )
    ]
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? ColorTheme.primaryYellow : ColorTheme.secondaryText.opacity(0.3))
                            .frame(width: index == currentPage ? 24 : 8, height: 8)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.top, 60)
                .padding(.bottom, 40)
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index], animateElements: animateElements)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .onChange(of: currentPage) { _ in
                    animateElements = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            animateElements = true
                        }
                    }
                }
                
                HStack(spacing: 20) {
                    if currentPage > 0 {
                        Button(action: {
                            withAnimation {
                                currentPage -= 1
                            }
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Previous")
                                    .font(FontManager.ubuntu(16, weight: .medium))
                            }
                            .foregroundColor(ColorTheme.primaryText)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(ColorTheme.secondaryButtonBackground)
                            .cornerRadius(20)
                        }
                    }
                                        
                    if currentPage < pages.count - 1 {
                        Button(action: {
                            withAnimation {
                                currentPage += 1
                            }
                        }) {
                            HStack {
                                Text("Next")
                                    .font(FontManager.ubuntu(16, weight: .medium))
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(ColorTheme.buttonText)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(ColorTheme.buttonBackground)
                            .cornerRadius(20)
                        }
                    } else {
                        Button(action: {
                            appState.completeOnboarding()
                        }) {
                            HStack {
                                Text("Get Started")
                                    .font(FontManager.ubuntu(18, weight: .medium))
                                    .foregroundColor(ColorTheme.buttonText)
                                
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(ColorTheme.buttonText)
                            }
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(ColorTheme.buttonBackground)
                            .cornerRadius(28)
                            .shadow(color: ColorTheme.primaryYellow.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            withAnimation {
                animateElements = true
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let animateElements: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.systemImage)
                .font(.system(size: 80))
                .foregroundColor(ColorTheme.primaryYellow)
                .scaleEffect(animateElements ? 1.0 : 0.5)
                .animation(.spring(response: 0.8, dampingFraction: 0.6), value: animateElements)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(FontManager.ubuntu(32, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                    .multilineTextAlignment(.center)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: animateElements)
                
                Text(page.description)
                    .font(FontManager.ubuntu(18, weight: .regular))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: animateElements)
            }
            
            Spacer()
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let systemImage: String
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
}
