import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentPage = 0
    @State private var showMainApp = false
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Style your jewelry",
            description: "Discover perfect jewelry for every outfit, try virtual looks, save your favorites, and create stylish combinations effortlessly.",
            icon: "sparkles",
            color: ColorTheme.primaryYellow
        ),
        OnboardingPage(
            title: "Virtual Try-On",
            description: "Experience jewelry like never before with AR technology. See how pieces look on you before making decisions.",
            icon: "camera.viewfinder",
            color: ColorTheme.primaryBlue
        ),
        OnboardingPage(
            title: "Build Your Collection",
            description: "Save your favorite pieces, track your style preferences, and get personalized recommendations.",
            icon: "heart.fill",
            color: ColorTheme.softPink
        )
    ]
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            GridPatternView()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    Button("Skip") {
                        appState.completeOnboarding()
                        showMainApp = true
                    }
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(ColorTheme.secondaryText)
                    .padding(.trailing, 20)
                    .padding(.top, 20)
                }
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 30) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? ColorTheme.primaryBlue : Color.gray)
                                .frame(width: currentPage == index ? 12 : 8, height: currentPage == index ? 12 : 8)
                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                        }
                    }
                    
                    HStack(spacing: 20) {
                        if currentPage > 0 {
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    currentPage -= 1
                                }
                            } label: {
                                Text("Previous")
                                    .font(.playfairDisplay(16, weight: .medium))
                                    .foregroundColor(ColorTheme.primaryBlue)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(ColorTheme.backgroundWhite)
                                            .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 5)
                                    )
                                
                            }
                            
                            Spacer()
                        }
                        
                        Button {
                            if currentPage == pages.count - 1 {
                                appState.completeOnboarding()
                                showMainApp = true
                            } else {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    currentPage += 1
                                }
                            }
                        } label: {
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Next")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(ColorTheme.whiteText)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(ColorTheme.primaryBlue)
                                        .shadow(color: ColorTheme.primaryBlue.opacity(0.3), radius: 10)
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 40)
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let icon: String
    let color: Color
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
                    .fill(page.color.opacity(0.1))
                    .frame(width: 160, height: 160)
                    .scaleEffect(animateIcon ? 1.1 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                        value: animateIcon
                    )
                
                Circle()
                    .fill(page.color.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .scaleEffect(animateIcon ? 0.9 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                        value: animateIcon
                    )
                
                Image(systemName: page.icon)
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(page.color)
                    .scaleEffect(animateIcon ? 1.2 : 1.0)
                    .animation(
                        Animation.spring(response: 0.8, dampingFraction: 0.6).repeatForever(autoreverses: true),
                        value: animateIcon
                    )
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.playfairDisplay(32, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                    .multilineTextAlignment(.center)
                    .opacity(animateText ? 1.0 : 0.7)
                    .animation(.easeInOut(duration: 1.0), value: animateText)
                
                Text(page.description)
                    .font(.playfairDisplay(18, weight: .medium))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(4)
                    .padding(.horizontal, 30)
                    .opacity(animateText ? 1.0 : 0.8)
                    .animation(.easeInOut(duration: 1.2), value: animateText)
            }
            
            Spacer()
        }
        .onAppear {
            animateIcon = true
            animateText = true
        }
    }
}

struct ContentView: View {
    var body: some View {
        OnboardingView()
            .environmentObject(AppState())
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
}
