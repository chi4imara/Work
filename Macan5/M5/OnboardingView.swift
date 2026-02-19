import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    let onComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            title: "Your beauty shelf, perfectly organized.",
            description: "Take full control of your beauty collection — what you use, what's waiting, and what you need to restock.",
            systemImage: "sparkles"
        ),
        OnboardingPage(
            title: "Never buy duplicates again",
            description: "Add every product once, track its status, and stop buying duplicates you already own.",
            systemImage: "checkmark.circle.fill"
        ),
        OnboardingPage(
            title: "Stay organized, stay smart",
            description: "Whether it's skincare, makeup, haircare, or perfumes — keep your shelves neat and your budget smart. Mark what's in use, move finished items to your shopping list, and always know exactly what you have.",
            systemImage: "heart.fill"
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
                
                VStack(spacing: 30) {
                    HStack(spacing: 12) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? ColorManager.primaryYellow : ColorManager.primaryBlue.opacity(0.3))
                                .frame(width: 12, height: 12)
                                .scaleEffect(index == currentPage ? 1.2 : 1.0)
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
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(FontManager.medium(size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    colors: [ColorManager.primaryBlue, ColorManager.accentPurple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(28)
                            .shadow(color: ColorManager.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 40)
                }
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
                .foregroundColor(ColorManager.primaryYellow)
                .shadow(color: ColorManager.primaryYellow.opacity(0.3), radius: 20, x: 0, y: 10)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(FontManager.bold(size: 28))
                    .foregroundColor(ColorManager.primaryBlue)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(FontManager.regular(size: 16))
                    .foregroundColor(ColorManager.darkGray)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
