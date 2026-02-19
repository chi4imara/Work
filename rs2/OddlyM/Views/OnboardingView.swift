import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: RitualViewModel
    @State private var currentPage = 0
    
    let pages = [
        OnboardingPage(
            icon: "sparkles",
            title: "Little rituals that define you.",
            description: "This app helps you capture the small rituals, habits, and quirks that make you who you are. Write them down, revisit them, and track how often they appear in your daily life. Over time, you'll see patterns that quietly shape your routines and give structure to the things you do without thinking."
        ),
        OnboardingPage(
            icon: "chart.line.uptrend.xyaxis",
            title: "Track your daily patterns.",
            description: "Mark your rituals as you complete them throughout the day. Watch as your personal patterns emerge over time. See which rituals become part of your routine and which ones are special moments worth remembering."
        ),
        OnboardingPage(
            icon: "star.fill",
            title: "Discover what makes you unique.",
            description: "Every small ritual tells a story. By tracking them, you'll gain insights into your daily life and understand the subtle ways these habits shape your identity. Start capturing your rituals today and see your patterns unfold."
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    OnboardingPageView(page: pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.bottom, 60)
            
            VStack {
                Spacer()
                
                pageIndicators
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        viewModel.completeOnboarding()
                    }
                }) {
                    Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                        .font(.appButton())
                        .foregroundColor(AppColors.textWhite)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColors.accentPurple)
                        .cornerRadius(12)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 50)
                }
            }
        }
    }
    
    private var pageIndicators: some View {
        HStack(spacing: 8) {
            ForEach(0..<pages.count, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? AppColors.accentPurple : AppColors.textSecondary.opacity(0.3))
                    .frame(width: index == currentPage ? 10 : 8, height: index == currentPage ? 10 : 8)
                    .animation(.easeInOut, value: currentPage)
            }
        }
        .padding(.bottom, 20)
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 30) {
                Image(systemName: page.icon)
                    .font(.system(size: 80))
                    .foregroundColor(AppColors.accentPurple)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .opacity(isAnimating ? 0.8 : 1.0)
                    .onAppear {
                        withAnimation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true)
                        ) {
                            isAnimating = true
                        }
                    }
                
                VStack(spacing: 20) {
                    Text(page.title)
                        .font(.appTitle())
                        .foregroundColor(AppColors.textWhite)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                    
                    Text(page.description)
                        .font(.appBody())
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .lineSpacing(4)
                }
            }
            
            Spacer()
        }
    }
}
