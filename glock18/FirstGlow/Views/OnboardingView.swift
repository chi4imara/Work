import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showMainApp = false
    
    var onComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            title: "Capture Your Firsts",
            description: "Record the special moments when you do something for the first time. From flying on a plane to playing chess, every new experience matters.",
            imageName: "airplane",
            color: AppColors.lightPurple
        ),
        OnboardingPage(
            title: "Remember Forever",
            description: "Save each experience with its date, category, place, and a personal note. Your memories stay organized and never forgotten.",
            imageName: "heart.fill",
            color: AppColors.softPink
        ),
        OnboardingPage(
            title: "Track Your Journey",
            description: "Browse your personal log, filter by time or category, and see which areas of life are richest in new experiences.",
            imageName: "chart.bar.fill",
            color: AppColors.mintGreen
        )
    ]
    
    var body: some View {
        ZStack {
            AnimatedBackgroundView()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 30) {
                    HStack(spacing: 12) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.accentYellow : AppColors.pureWhite.opacity(0.4))
                                .frame(width: currentPage == index ? 12 : 8, height: currentPage == index ? 12 : 8)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentPage += 1
                            }
                        } else {
                            print("✅ Onboarding completed - calling onComplete")
                            onComplete()
                        }
                    }) {
                        HStack {
                            Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .medium))
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
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
                    .fill(page.color.opacity(0.2))
                    .frame(width: 160, height: 160)
                    .scaleEffect(animateIcon ? 1.1 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true),
                        value: animateIcon
                    )
                
                Circle()
                    .fill(page.color.opacity(0.3))
                    .frame(width: 120, height: 120)
                
                Image(systemName: page.imageName)
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(AppColors.pureWhite)
                    .shadow(color: page.color, radius: 10)
            }
            .offset(y: animateText ? 0 : 20)
            .opacity(animateText ? 1 : 0)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(FontManager.title1)
                    .foregroundColor(AppColors.pureWhite)
                    .multilineTextAlignment(.center)
                    .offset(y: animateText ? 0 : 30)
                    .opacity(animateText ? 1 : 0)
                
                Text(page.description)
                    .font(FontManager.body)
                    .foregroundColor(AppColors.pureWhite.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .offset(y: animateText ? 0 : 40)
                    .opacity(animateText ? 1 : 0)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                animateText = true
            }
            
            withAnimation(.easeInOut(duration: 1.0).delay(0.5)) {
                animateIcon = true
            }
        }
    }
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
