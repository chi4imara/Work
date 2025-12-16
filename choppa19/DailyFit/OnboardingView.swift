import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var opacity: Double = 0
    let onComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            title: "Find your look in seconds.",
            description: "Collect your favorite everyday outfits and never run out of ideas again.",
            imageName: "figure.dress.line.vertical.figure"
        ),
        OnboardingPage(
            title: "Save & Organize",
            description: "Save your go-to looks with photos, moods, and seasons — from casual jeans to cozy dresses.",
            imageName: "heart.text.square"
        ),
        OnboardingPage(
            title: "Plan Your Week",
            description: "Plan your week, browse your favorites, and always know what to wear, no matter the day.",
            imageName: "calendar"
        ),
        OnboardingPage(
            title: "Your Personal Library",
            description: "Your personal outfit library — simple, smart, and always at hand.",
            imageName: "books.vertical"
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.mainBackgroundGradient
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                ForEach(0..<8, id: \.self) { i in
                    Circle()
                        .fill(Color.white.opacity(0.05))
                        .frame(width: CGFloat.random(in: 50...150))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                }
            }
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                VStack(spacing: 30) {
                    HStack(spacing: 12) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.primaryYellow : Color.white.opacity(0.4))
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
                            onComplete()
                        }
                    }) {
                        HStack {
                            Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(AppColors.buttonText)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(AppColors.buttonText)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(AppColors.buttonBackground)
                        )
                        .shadow(color: AppColors.buttonBackground.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 32)
                    
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            onComplete()
                        }
                        .font(.ubuntu(16))
                        .foregroundColor(AppColors.secondaryText)
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                opacity = 1.0
            }
        }
        .opacity(opacity)
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
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
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 160, height: 160)
                
                Image(systemName: page.imageName)
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(AppColors.primaryYellow)
                    .scaleEffect(imageScale)
                    .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2), value: imageScale)
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .opacity(textOpacity)
                    .animation(.easeInOut(duration: 0.8).delay(0.4), value: textOpacity)
                
                Text(page.description)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .opacity(textOpacity)
                    .animation(.easeInOut(duration: 0.8).delay(0.6), value: textOpacity)
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
        .onAppear {
            imageScale = 1.0
            textOpacity = 1.0
        }
    }
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
