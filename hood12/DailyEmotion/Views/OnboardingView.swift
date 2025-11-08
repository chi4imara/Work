import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var isOnboardingCompleted: Bool
    
    let pages = [
        OnboardingPage(
            icon: "heart.fill",
            title: "Daily Mood Journal",
            subtitle: "Track and Understand Yourself",
            description: "Welcome to your personal emotion tracking companion. Start your journey of self-awareness and emotional intelligence."
        ),
        OnboardingPage(
            icon: "face.smiling",
            title: "Express Your Emotions",
            subtitle: "Six Core Feelings",
            description: "Choose from joy, calm, tired, angry, bored, or success. Each emotion tells a story about your day and helps you understand patterns."
        ),
        OnboardingPage(
            icon: "pencil.and.outline",
            title: "Write Your Story",
            subtitle: "Capture the Why",
            description: "Every emotion has a reason. Write down what triggered your feelings - from small victories to challenging moments."
        ),
        OnboardingPage(
            icon: "archivebox.fill",
            title: "Your Personal Archive",
            subtitle: "Reflect and Grow",
            description: "Your entries are safely stored and organized. Use filters to find patterns, track progress, and gain insights into your emotional journey."
        ),
        OnboardingPage(
            icon: "chart.line.uptrend.xyaxis",
            title: "Discover Insights",
            subtitle: "Learn About Yourself",
            description: "View statistics, track trends, and understand your emotional patterns. Knowledge is the first step to positive change."
        )
    ]
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                VStack(spacing: 30) {
                    HStack(spacing: 12) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.accentYellow : AppColors.primaryText.opacity(0.3))
                                .frame(width: 12, height: 12)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.spring(response: 0.3), value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage += 1
                            }
                        } else {
                            print("✅ Onboarding completed! Setting isOnboardingCompleted to true")
                            isOnboardingCompleted = true
                        }
                    }) {
                        HStack {
                            Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                                .font(.poppinsSemiBold(size: 18))
                                .foregroundColor(AppColors.primaryBlue)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(AppColors.primaryBlue)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(AppColors.accentYellow)
                        .cornerRadius(28)
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let subtitle: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.icon)
                .font(.system(size: 70, weight: .light))
                .foregroundColor(AppColors.accentYellow)
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.poppinsBold(size: 25))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(page.subtitle)
                    .font(.poppinsMedium(size: 17))
                    .foregroundColor(AppColors.accentYellow)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.poppinsRegular(size: 15))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    OnboardingView(isOnboardingCompleted: .constant(false))
}
