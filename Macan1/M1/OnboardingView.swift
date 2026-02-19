import SwiftUI

struct OnboardingView: View {
    @Binding var isCompleted: Bool
    @State private var currentPage = 0
    
    let pages = [
        OnboardingPage(
            image: "paintbrush.pointed.fill",
            title: "Organize your beauty in one place",
            description: "Create your personal makeup catalog and keep every detail at your fingertips. Add your favorite products, note their shades, track expiration dates, and rate what truly works for you."
        ),
        OnboardingPage(
            image: "magnifyingglass",
            title: "Find what you need instantly",
            description: "Filter by brand or type to find what you need in seconds — from lipsticks to skincare. See which items are about to expire and keep your beauty shelf fresh and organized."
        ),
        OnboardingPage(
            image: "lock.shield.fill",
            title: "Private and secure",
            description: "Each entry stays local on your device, giving you a clear and private overview of your entire collection. Simple, elegant, and made to help you stay in control of your cosmetics."
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
                .animation(.easeInOut, value: currentPage)
                
                HStack(spacing: 12) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? AppColors.primaryYellow : AppColors.primaryWhite.opacity(0.3))
                            .frame(width: 10, height: 10)
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
                        isCompleted = true
                    }
                }) {
                    HStack {
                        Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(AppColors.backgroundGradientStart)
                        
                        if currentPage < pages.count - 1 {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppColors.backgroundGradientStart)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(AppColors.primaryYellow)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -50 && currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    } else if value.translation.width > 50 && currentPage > 0 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage -= 1
                        }
                    }
                }
        )
    }
}

struct OnboardingPage {
    let image: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.primaryWhite.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: page.image)
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(AppColors.primaryYellow)
            }
            
            VStack(spacing: 24) {
                Text(page.title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(isCompleted: .constant(false))
}
