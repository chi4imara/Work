import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var offset: CGFloat = 0
    var onComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            title: "Take Care of Yourself Every Day",
            description: "Track your mood, capture thoughts, create mini-rituals for emotional wellness.",
            systemImage: "heart.fill",
            color: AppColors.softPink
        ),
        OnboardingPage(
            title: "Small Steps - Harmony and Peace",
            description: "Build habits, participate in mini-challenges and track your progress.",
            systemImage: "leaf.fill",
            color: AppColors.lightGreen
        ),
        OnboardingPage(
            title: "Let's Start Together",
            description: "Daily tasks, visual rewards and micro-support will help you feel better every day.",
            systemImage: "sparkles",
            color: AppColors.primaryYellow
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            FloatingBubblesView()
                .opacity(0.4)
            
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? AppColors.primaryBlue : AppColors.primaryBlue.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.top, 60)
                .padding(.bottom, 40)
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage += 1
                        }
                    } else {
                        onComplete()
                    }
                }) {
                    HStack {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        if currentPage < pages.count - 1 {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 28)
                            .fill(
                                LinearGradient(
                                    colors: [AppColors.primaryBlue, AppColors.primaryBlue.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
                    .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var imageScale: CGFloat = 0.8
    @State private var textOpacity: Double = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: page.systemImage)
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(page.color)
            }
            .scaleEffect(imageScale)
            .animation(.spring(response: 0.8, dampingFraction: 0.6), value: imageScale)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.playfairDisplay(28, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 20)
            }
            .opacity(textOpacity)
            .animation(.easeIn(duration: 0.8).delay(0.3), value: textOpacity)
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 32)
        .onAppear {
            imageScale = 1.0
            textOpacity = 1.0
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let systemImage: String
    let color: Color
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
