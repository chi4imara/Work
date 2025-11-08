import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var animateContent = false
    let onComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            title: "Your Personal Recipe Library",
            description: "Collect, organize, and cook your favorite dishes with a clean, fast recipe library.",
            imageName: "book.fill",
            color: Color.primaryPurple
        ),
        OnboardingPage(
            title: "Smart Organization",
            description: "Add ingredients and step-by-step instructions, mark servings and total time, tag recipes for easy search.",
            imageName: "square.grid.3x3.fill",
            color: Color.accentOrange
        ),
        OnboardingPage(
            title: "Focused Cooking Mode",
            description: "Cook in a focused step mode. From quick snacks to family dinners — keep everything in one tidy place and find the right recipe in seconds.",
            imageName: "timer",
            color: Color.accentPink
        )
    ]
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(
                            page: pages[index],
                            isActive: currentPage == index,
                            animateContent: animateContent
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                VStack(spacing: 30) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.white : Color.white.opacity(0.4))
                                .frame(width: 8, height: 8)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    VStack(spacing: 16) {
                        if currentPage < pages.count - 1 {
                            Button(action: nextPage) {
                                HStack {
                                    Text("Continue")
                                        .font(AppFonts.buttonLarge)
                                        .foregroundColor(.white)
                                    
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    LinearGradient.buttonGradient
                                )
                                .cornerRadius(16)
                                .shadow(color: Color.primaryPurple.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            
                            Button(action: onComplete) {
                                Text("Skip")
                                    .font(AppFonts.buttonMedium)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        } else {
                            Button(action: onComplete) {
                                HStack {
                                    Text("Get Started")
                                        .font(AppFonts.buttonLarge)
                                        .foregroundColor(.white)
                                    
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    LinearGradient.buttonGradient
                                )
                                .cornerRadius(16)
                                .shadow(color: Color.primaryPurple.opacity(0.3), radius: 8, x: 0, y: 4)
                                .scaleEffect(animateContent ? 1.05 : 1.0)
                                .animation(
                                    Animation.easeInOut(duration: 1.0)
                                        .repeatForever(autoreverses: true),
                                    value: animateContent
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 32)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            animateContent = true
        }
    }
    
    private func nextPage() {
        withAnimation(.easeInOut(duration: 0.5)) {
            if currentPage < pages.count - 1 {
                currentPage += 1
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let isActive: Bool
    let animateContent: Bool
    
    @State private var imageScale: CGFloat = 0.8
    @State private var textOpacity: Double = 0.0
    @State private var iconRotation: Double = 0.0
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [page.color.opacity(0.3), page.color.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 160, height: 160)
                    .scaleEffect(imageScale)
                
                Image(systemName: page.imageName)
                    .font(.system(size: 60, weight: .medium))
                    .foregroundColor(page.color)
                    .rotationEffect(.degrees(iconRotation))
            }
            .shadow(color: page.color.opacity(0.3), radius: 20, x: 0, y: 10)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(AppFonts.titleLarge)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .opacity(textOpacity)
                
                Text(page.description)
                    .font(AppFonts.bodyLarge)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .opacity(textOpacity)
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
        .onChange(of: isActive) { active in
            if active {
                animateIn()
            }
        }
        .onAppear {
            if isActive {
                animateIn()
            }
        }
    }
    
    private func animateIn() {
        imageScale = 0.8
        textOpacity = 0.0
        iconRotation = -10.0
        
        withAnimation(.easeOut(duration: 0.6).delay(0.1)) {
            imageScale = 1.0
        }
        
        withAnimation(.easeOut(duration: 0.5).delay(0.3)) {
            textOpacity = 1.0
        }
        
        withAnimation(.easeInOut(duration: 0.8).delay(0.2)) {
            iconRotation = 0.0
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
    let color: Color
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
