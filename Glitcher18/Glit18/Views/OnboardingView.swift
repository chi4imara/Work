import SwiftUI

struct OnboardingView: View {
    @Binding var isShowingOnboarding: Bool
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    private let pages = [
        OnboardingPage(
            title: "Keep every accessory organized.",
            description: "Build a clean, structured catalog for your accessories. Sort items into categories, add notes, and mark which outfits they match.",
            systemImage: "sparkles"
        ),
        OnboardingPage(
            title: "Create perfect combinations",
            description: "Create a simple way to plan your looks and keep everything easy to find, so every piece fits perfectly into your wardrobe.",
            systemImage: "heart.fill"
        ),
        OnboardingPage(
            title: "Track your style journey",
            description: "Monitor your collection growth, see your most used accessories, and discover new outfit possibilities with detailed statistics.",
            systemImage: "chart.bar.fill"
        ),
        OnboardingPage(
            title: "Your personal style assistant",
            description: "Get insights into your fashion choices, explore different combinations, and build a wardrobe that truly reflects your unique style.",
            systemImage: "star.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                ForEach(0..<5, id: \.self) { index in
                    Circle()
                        .fill(AppColors.accentYellow.opacity(0.1))
                        .frame(width: CGFloat.random(in: 50...120))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .animation(.easeInOut(duration: Double.random(in: 2...4)).repeatForever(autoreverses: true).delay(Double(index) * 0.5), value: isAnimating)
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
                .frame(maxHeight: .infinity)
                
                VStack(spacing: 24) {
                    HStack(spacing: 12) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.accentYellow : AppColors.primaryText.opacity(0.3))
                                .frame(width: 12, height: 12)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentPage += 1
                            }
                        } else {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                isShowingOnboarding = true
                            }
                        }
                    }) {
                        Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                            .primaryButton()
                    }
                    
                    if currentPage == 0 {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                isShowingOnboarding = true
                            }
                        }) {
                            Text("Skip")
                                .font(.playfairDisplay(size: 16, weight: .medium))
                                .foregroundColor(AppColors.secondaryText)
                        }
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var isVisible = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.accentGradient)
                    .frame(width: 120, height: 120)
                    .scaleEffect(isVisible ? 1.0 : 0.5)
                    .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2), value: isVisible)
                
                Image(systemName: page.systemImage)
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(AppColors.deepPurple)
                    .scaleEffect(isVisible ? 1.0 : 0.5)
                    .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.4), value: isVisible)
            }
            
            VStack(spacing: 24) {
                Text(page.title)
                    .font(.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .offset(y: isVisible ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: isVisible)
                
                Text(page.description)
                    .font(.playfairDisplay(size: 18, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .offset(y: isVisible ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.8), value: isVisible)
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
        .onAppear {
            isVisible = true
        }
        .onDisappear {
            isVisible = false
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let systemImage: String
}

#Preview {
    OnboardingView(isShowingOnboarding: .constant(true))
}
