import SwiftUI

struct OnboardingView: View {
    @Binding var isShowingOnboarding: Bool
    @State private var currentPage = 0
    
    let onboardingPages = [
        OnboardingPage(
            icon: "applewatch.watchface",
            iconOffset: CGPoint(x: 30, y: -20),
            secondaryIcon: "plus.circle.fill",
            title: "Create your personal watch catalog.",
            description: "Add every watch you own with purchase details, style and condition. Track when you wear each piece, browse your full collection and keep a clean record of your watches. A simple way to organize your collection and follow your wearing habits."
        ),
        OnboardingPage(
            icon: "list.bullet.clipboard",
            iconOffset: nil,
            secondaryIcon: nil,
            title: "Organize Your Collection",
            description: "Keep track of all your watches in one place. Add details like purchase date, style, and condition. View your complete collection anytime and manage it effortlessly."
        ),
        OnboardingPage(
            icon: "chart.bar.fill",
            iconOffset: nil,
            secondaryIcon: nil,
            title: "Track Your Wearing Habits",
            description: "Mark the days you wear each watch and see detailed statistics. Understand your preferences and make informed decisions about your collection."
        )
    ]
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingPages.count, id: \.self) { index in
                        OnboardingPageView(page: onboardingPages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 20) {
                    PageIndicator(currentPage: currentPage, numberOfPages: onboardingPages.count)
                    
                    HStack(spacing: 16) {
                        if currentPage > 0 {
                            Button(action: {
                                withAnimation {
                                    currentPage -= 1
                                }
                            }) {
                                HStack {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 16, weight: .semibold))
                                    
                                    Text("Previous")
                                        .font(.playfairDisplay(size: 16, weight: .semibold))
                                }
                                .foregroundColor(ColorManager.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(ColorManager.lightBlue.opacity(0.7))
                                .cornerRadius(25)
                            }
                        }
                        
                        Button(action: {
                            if currentPage < onboardingPages.count - 1 {
                                withAnimation {
                                    currentPage += 1
                                }
                            } else {
                                DataManager.shared.setHasSeenOnboarding(true)
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    isShowingOnboarding = false
                                }
                            }
                        }) {
                            HStack {
                                Text(currentPage < onboardingPages.count - 1 ? "Next" : "Continue")
                                    .font(.playfairDisplay(size: 18, weight: .semibold))
                                    .foregroundColor(ColorManager.white)
                                
                                Image(systemName: currentPage < onboardingPages.count - 1 ? "arrow.right" : "checkmark.circle.fill")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(ColorManager.white)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                LinearGradient(
                                    colors: [ColorManager.lightBlue, ColorManager.orange],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(28)
                            .shadow(color: ColorManager.lightBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                }
            }
        }
    }
}

struct OnboardingPage {
    let icon: String
    let iconOffset: CGPoint?
    let secondaryIcon: String?
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 20) {
                if let offset = page.iconOffset, let secondary = page.secondaryIcon {
                    ZStack {
                        Image(systemName: page.icon)
                            .font(.system(size: 80, weight: .thin))
                            .foregroundColor(ColorManager.lightBlue)
                        
                        Image(systemName: secondary)
                            .font(.system(size: 24))
                            .foregroundColor(ColorManager.orange)
                            .offset(x: offset.x, y: offset.y)
                    }
                } else {
                    Image(systemName: page.icon)
                        .font(.system(size: 80, weight: .thin))
                        .foregroundColor(ColorManager.lightBlue)
                }
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text(page.description)
                    .font(.playfairDisplay(size: 16, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 30)
            }
            
            Spacer()
        }
    }
}

struct PageIndicator: View {
    let currentPage: Int
    let numberOfPages: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<numberOfPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? ColorManager.lightBlue : ColorManager.secondaryText.opacity(0.3))
                    .frame(width: index == currentPage ? 10 : 8, height: index == currentPage ? 10 : 8)
                    .animation(.easeInOut, value: currentPage)
            }
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    OnboardingView(isShowingOnboarding: .constant(true))
}
