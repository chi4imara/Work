import SwiftUI

struct OnboardingView: View {
    let onComplete: () -> Void
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    private let pages = [
        OnboardingPage(
            title: "Plan your garage shopping.",
            description: "Create a clear list of parts, oils and materials you need for your garage projects.",
            iconName: "wrench.and.screwdriver"
        ),
        OnboardingPage(
            title: "Stay Organized",
            description: "Add items with categories, quantities and notes to keep everything organized.",
            iconName: "list.clipboard"
        ),
        OnboardingPage(
            title: "Build Your Plan",
            description: "Build a structured shopping plan and revisit it whenever you prepare for repairs.",
            iconName: "checkmark.circle"
        )
    ]
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
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
                            .fill(index == currentPage ? ColorManager.orange : ColorManager.white.opacity(0.3))
                            .frame(width: 10, height: 10)
                            .scaleEffect(index == currentPage ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3), value: currentPage)
                    }
                }
                .padding(.vertical, 30)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    } else {
                        onComplete()
                    }
                }) {
                    HStack {
                        Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                            .font(FontManager.ubuntu(size: 18, weight: .medium))
                            .foregroundColor(ColorManager.white)
                        
                        if currentPage < pages.count - 1 {
                            Image(systemName: "arrow.right")
                                .foregroundColor(ColorManager.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(ColorManager.buttonGradient)
                    .cornerRadius(16)
                    .shadow(color: ColorManager.lightBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
                
                if currentPage < pages.count - 1 {
                    Button("Skip") {
                        onComplete()
                    }
                    .font(FontManager.ubuntu(size: 16))
                    .foregroundColor(ColorManager.white.opacity(0.7))
                    .padding(.bottom, 30)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                isAnimating = true
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let iconName: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var isVisible = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(ColorManager.cardGradient)
                    .frame(width: 120, height: 120)
                    .shadow(color: ColorManager.darkBlue.opacity(0.3), radius: 20, x: 0, y: 10)
                
                Image(systemName: page.iconName)
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(ColorManager.lightBlue)
            }
            .scaleEffect(isVisible ? 1.0 : 0.8)
            .opacity(isVisible ? 1.0 : 0.0)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(FontManager.ubuntu(size: 28, weight: .bold))
                    .foregroundColor(ColorManager.white)
                    .multilineTextAlignment(.center)
                    .offset(y: isVisible ? 0 : 30)
                    .opacity(isVisible ? 1.0 : 0.0)
                
                Text(page.description)
                    .font(FontManager.ubuntu(size: 16))
                    .foregroundColor(ColorManager.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 40)
                    .offset(y: isVisible ? 0 : 30)
                    .opacity(isVisible ? 1.0 : 0.0)
            }
            
            Spacer()
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                isVisible = true
            }
        }
    }
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
