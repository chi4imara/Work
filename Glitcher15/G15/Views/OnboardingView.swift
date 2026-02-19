import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboardingComplete: Bool
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            title: "Keep your bag perfectly organized.",
            description: "Create lists of the items you carry, switch between setups for different occasions, and keep everything in order.",
            imageName: "bag.fill"
        ),
        OnboardingPage(
            title: "Build custom bag layouts.",
            description: "Track what you need to take with you, and update your essentials anytime with ease.",
            imageName: "list.bullet.rectangle"
        ),
        OnboardingPage(
            title: "Organize by categories.",
            description: "Group your items into categories like Documents, Gadgets, Cosmetics, and more for easy access and better organization.",
            imageName: "folder.fill"
        ),
        OnboardingPage(
            title: "Never forget anything again.",
            description: "Mark items as in your bag, create multiple sets for different situations, and always know what you have with you.",
            imageName: "checkmark.circle.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        OnboardingPageView(page: page)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 24) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.yellow : AppColors.secondaryText.opacity(0.3))
                                .frame(width: 10, height: 10)
                                .animation(.easeInOut, value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut) {
                                currentPage += 1
                            }
                        } else {
                            withAnimation(.easeInOut) {
                                isOnboardingComplete = true
                            }
                        }
                    }) {
                        Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                            .font(FontManager.playfairSemiBold(size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(AppColors.accentGradient)
                            )
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
    let imageName: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 30) {
                Image(systemName: page.imageName)
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(AppColors.yellow)
                
                HStack(spacing: 20) {
                    Circle()
                        .fill(AppColors.yellow.opacity(0.3))
                        .frame(width: 20, height: 20)
                    
                    Circle()
                        .fill(AppColors.purple.opacity(0.3))
                        .frame(width: 16, height: 16)
                    
                    Circle()
                        .fill(AppColors.mint.opacity(0.3))
                        .frame(width: 24, height: 24)
                }
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(FontManager.playfairBold(size: 28))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(FontManager.playfairRegular(size: 16))
                    .foregroundColor(AppColors.secondaryText)
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
    OnboardingView(isOnboardingComplete: .constant(false))
}
