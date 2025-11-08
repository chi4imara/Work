import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var isCompleting = false
    
    let onComplete: () -> Void
    
    init(onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
    }
    
    private let pages = [
        OnboardingPage(
            title: "Keep every celebration in sight",
            description: "Life is full of important dates — from birthdays and anniversaries to fun little holidays like Coffee Day or Hug Day.",
            systemImage: "calendar.badge.plus"
        ),
        OnboardingPage(
            title: "Never miss a special moment",
            description: "This app helps you keep them all in one place. Create your own list of personal events, mark family celebrations, and discover unusual holidays.",
            systemImage: "heart.fill"
        ),
        OnboardingPage(
            title: "Stay organized and joyful",
            description: "The main calendar view shows you everything by day, so you'll never miss a special moment. Important dates can be saved to your favorites for quick access.",
            systemImage: "star.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
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
                            .fill(currentPage == index ? AppColors.accent : AppColors.lightGray)
                            .frame(width: 10, height: 10)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.vertical, 30)
                
                VStack(spacing: 16) {
                    Button(action: {
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
                        
                        print("Button tapped! Current page: \(currentPage), Total pages: \(pages.count)")
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentPage += 1
                            }
                        } else {
                            print("🎉 GET STARTED BUTTON PRESSED!")
                            isCompleting = true
                            
                            onComplete()
                        }
                    }) {
                        HStack {
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                                .font(FontManager.subheadline)
                                .foregroundColor(AppColors.background)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(AppColors.background)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(AppColors.accent)
                        .cornerRadius(28)
                    }
                    .buttonStyle(OnboardingButtonStyle())
                    .scaleEffect(currentPage == pages.count - 1 ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: currentPage)
                    .disabled(isCompleting)
                    .opacity(isCompleting ? 0.7 : 1.0)
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
    let systemImage: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.systemImage)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.accent)
                .padding(.bottom, 20)
            
            Text(page.title)
                .font(FontManager.title)
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Text(page.description)
                .font(FontManager.body)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct OnboardingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    OnboardingView(onComplete: {
        print("Preview: Onboarding completed")
    })
}
