import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var contentOpacity: Double = 0
    @State private var buttonScale: CGFloat = 0.8
    
    let onComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            image: "leaf.circle.fill",
            title: "Repot with Care. Track Every Growth.",
            description: "This app helps you document every repotting and care note for your plants. Each time you repot, you can log the date, type of plant, pot size, soil details, and special notes — all in one simple place."
        ),
        OnboardingPage(
            image: "book.circle.fill",
            title: "Your Personal Plant Diary",
            description: "Over time, your journal becomes a personal plant diary that shows when each plant got a new home and how it responded to your care. It's easy, clear, and built for plant lovers who value order and growth."
        ),
        OnboardingPage(
            image: "wand.and.stars.inverse",
            title: "Beautiful Animated Design",
            description: "Enjoy a calming gradient background with floating orbs and smooth animations that make your plant journaling feel delightful and modern."
        ),
        OnboardingPage(
            image: "slider.horizontal.3",
            title: "Powerful Tools",
            description: "Filter by time period, search by notes or plant name, sort your records, and quickly add new repottings — all in one place."
        )
    ]
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .opacity(contentOpacity)
                
                VStack(spacing: 30) {
                    HStack(spacing: 12) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.primaryBlue : AppColors.textTertiary)
                                .frame(width: 10, height: 10)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    Button(action: handleContinueAction) {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(AppFonts.headline(.semiBold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(AppColors.primaryBlue)
                            .cornerRadius(25)
                            .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .scaleEffect(buttonScale)
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            startOnboardingAnimation()
        }
    }
    
    private func startOnboardingAnimation() {
        withAnimation(.easeOut(duration: 0.8)) {
            contentOpacity = 1.0
        }
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            buttonScale = 1.0
        }
    }
    
    private func handleContinueAction() {
        if currentPage < pages.count - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentPage += 1
            }
        } else {
            onComplete()
        }
    }
}

struct OnboardingPage {
    let image: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var imageScale: CGFloat = 0.8
    @State private var textOpacity: Double = 0
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardBackground)
                    .frame(width: 140, height: 140)
                    .shadow(color: AppColors.primaryBlue.opacity(0.2), radius: 15, x: 0, y: 8)
                
                Image(systemName: page.image)
                    .font(.system(size: 60))
                    .foregroundColor(AppColors.primaryBlue)
            }
            .scaleEffect(imageScale)
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(AppFonts.title(.bold))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(AppFonts.body(.regular))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 30)
            .opacity(textOpacity)
            
            Spacer()
        }
        .onAppear {
            startPageAnimation()
        }
    }
    
    private func startPageAnimation() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
            imageScale = 1.0
        }
        
        withAnimation(.easeOut(duration: 0.8).delay(0.4)) {
            textOpacity = 1.0
        }
    }
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
