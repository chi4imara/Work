import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appState: AppStateManager
    @State private var currentPage = 0
    @State private var animateContent = false
    
    private let pages = OnboardingPage.allPages
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index], isActive: currentPage == index)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: AppSpacing.lg) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.primaryOrange : AppColors.primaryText.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut, value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut) {
                                currentPage += 1
                            }
                        } else {
                            appState.completeOnboarding()
                        }
                    }) {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppSpacing.md)
                            .background(AppColors.primaryOrange)
                            .cornerRadius(AppCornerRadius.medium)
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .scaleEffect(animateContent ? 1.0 : 0.8)
                    .opacity(animateContent ? 1.0 : 0.0)
                }
                .padding(.bottom, AppSpacing.xl)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                animateContent = true
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -50 && currentPage < pages.count - 1 {
                        withAnimation(.easeInOut) {
                            currentPage += 1
                        }
                    } else if value.translation.width > 50 && currentPage > 0 {
                        withAnimation(.easeInOut) {
                            currentPage -= 1
                        }
                    }
                }
        )
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let isActive: Bool
    @State private var animateImage = false
    @State private var animateText = false
    
    var body: some View {
        VStack(spacing: AppSpacing.xl) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 200, height: 200)
                    .scaleEffect(animateImage ? 1.0 : 0.5)
                    .opacity(animateImage ? 1.0 : 0.0)
                
                Image(systemName: page.iconName)
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(AppColors.primaryOrange)
                    .scaleEffect(animateImage ? 1.0 : 0.3)
                    .rotationEffect(.degrees(animateImage ? 0 : 180))
            }
            
            Spacer()
            
            VStack(spacing: AppSpacing.lg) {
                Text(page.title)
                    .font(AppFonts.largeTitle)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .offset(y: animateText ? 0 : 50)
                    .opacity(animateText ? 1.0 : 0.0)
                
                Text(page.description)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .offset(y: animateText ? 0 : 30)
                    .opacity(animateText ? 1.0 : 0.0)
            }
            .padding(.horizontal, AppSpacing.lg)
            
            Spacer()
        }
        .onChange(of: isActive) { active in
            if active {
                withAnimation(.easeInOut(duration: 0.6)) {
                    animateImage = true
                }
                withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                    animateText = true
                }
            }
        }
        .onAppear {
            if isActive {
                withAnimation(.easeInOut(duration: 0.6)) {
                    animateImage = true
                }
                withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                    animateText = true
                }
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let iconName: String
    
    static let allPages = [
        OnboardingPage(
            title: "Color Your Weather",
            description: "This app lets you record the weather of each day with a color. Choose a shade that reflects the day — bright yellow for sunshine, gray for clouds, blue for cold, or any other.",
            iconName: "sun.max.fill"
        ),
        OnboardingPage(
            title: "Visual Weather Diary",
            description: "Your calendar fills up with colors, turning into a visual diary of the weather you've experienced. Browse through the list of days and explore categories of colors.",
            iconName: "calendar"
        ),
        OnboardingPage(
            title: "Track & Analyze",
            description: "Check the statistics to see which shades appear most often. Simple, visual, and personal — your weather in colors, day by day.",
            iconName: "chart.bar.fill"
        )
    ]
}

#Preview {
    OnboardingView(appState: AppStateManager())
}
