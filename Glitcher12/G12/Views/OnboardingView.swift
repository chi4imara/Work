import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    @State private var opacity: Double = 0
    
    let pages = [
        OnboardingPage(
            title: "Keep your manicure ideas organized.",
            description: "Save your favorite nail designs, note the colors used, and keep track of the masters you liked.",
            systemImage: "paintbrush.pointed.fill"
        ),
        OnboardingPage(
            title: "Build your personal history",
            description: "Build a personal manicure history, collect inspiration, and easily return to the looks you want to repeat—all in one simple and elegant place.",
            systemImage: "heart.fill"
        ),
        OnboardingPage(
            title: "Track colors and masters",
            description: "Easily find all manicures by color or master. Keep track of your favorite combinations and discover new ideas from your collection.",
            systemImage: "paintpalette.fill"
        ),
        OnboardingPage(
            title: "Never forget a design",
            description: "Add notes, dates, and details to each manicure. Mark favorites and quickly access your most loved designs whenever you need inspiration.",
            systemImage: "star.fill"
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
                .animation(.easeInOut, value: currentPage)
                
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? ColorManager.yellow : ColorManager.white.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                .padding(.bottom, 40)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut) {
                            currentPage += 1
                        }
                    } else {
                        withAnimation(.easeInOut) {
                            showOnboarding = false
                        }
                    }
                }) {
                    Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(ColorManager.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(ColorManager.primaryButton)
                        .cornerRadius(25)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeIn(duration: 0.5)) {
                opacity = 1
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
                .font(.system(size: 80))
                .foregroundColor(ColorManager.yellow)
                .padding(.bottom, 20)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(ColorManager.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Text(page.description)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
