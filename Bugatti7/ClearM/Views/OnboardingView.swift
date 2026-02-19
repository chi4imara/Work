import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    let pages = [
        OnboardingPage(
            title: "Record important events as facts.",
            description: "This app helps you capture significant events such as meetings, deals, trips, and agreements. You record only the fact and the date, creating a clear timeline of what actually happened.",
            systemImage: "calendar.badge.plus"
        ),
        OnboardingPage(
            title: "Simple timeline tracking",
            description: "It's a simple way to keep track of meaningful moments without interpretation, analysis, or extra context. Just facts and dates.",
            systemImage: "timeline.selection"
        ),
        OnboardingPage(
            title: "View and organize anytime",
            description: "Browse your events in a list, on a calendar, or search by name and date. Edit or remove entries whenever you need. Your timeline stays under your control.",
            systemImage: "square.grid.2x2"
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GridBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                HStack(spacing: 12) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? AppColors.primaryYellow : AppColors.primaryWhite.opacity(0.3))
                            .frame(width: 12, height: 12)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 40)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    } else {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showOnboarding = false
                        }
                    }
                }) {
                    HStack {
                        Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                            .font(AppFonts.headline())
                            .foregroundColor(AppColors.primaryBlack)
                        
                        if currentPage < pages.count - 1 {
                            Image(systemName: "arrow.right")
                                .foregroundColor(AppColors.primaryBlack)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(AppColors.primaryYellow)
                    .cornerRadius(AppConstants.cornerRadius)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6)) {
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
    @State private var isVisible = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.primaryWhite.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: page.systemImage)
                    .font(.system(size: 48, weight: .light))
                    .foregroundColor(AppColors.primaryYellow)
            }
            .scaleEffect(isVisible ? 1.0 : 0.8)
            .opacity(isVisible ? 1.0 : 0.0)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(AppFonts.title(28))
                    .foregroundColor(AppColors.primaryWhite)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .opacity(isVisible ? 1.0 : 0.0)
                
                Text(page.description)
                    .font(AppFonts.body(16))
                    .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .opacity(isVisible ? 1.0 : 0.0)
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                isVisible = true
            }
        }
    }
}
