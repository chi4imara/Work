import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var isOnboardingComplete: Bool
    
    private let pages = [
        OnboardingPage(
            title: "Track your hair care routine",
            description: "Keep all your hair care details in one place. Add the products you use, record when you last cut or dyed your hair.",
            imageName: "drop.circle.fill"
        ),
        OnboardingPage(
            title: "Discover your favorites",
            description: "See which items you reach for the most. Your personal hair diary helps you stay consistent and mindful with every treatment.",
            imageName: "star.circle.fill"
        ),
        OnboardingPage(
            title: "From daily care to salon visits",
            description: "Simple, organized, and made for your perfect routine. Track everything from daily shampoos to occasional salon visits.",
            imageName: "scissors.circle.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button("Skip") {
                        completeOnboarding()
                    }
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.primaryText.opacity(0.7))
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 30) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.yellow : AppColors.primaryText.opacity(0.3))
                                .frame(width: 8, height: 8)
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
                            completeOnboarding()
                        }
                    }) {
                        Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                            .font(AppFonts.button)
                            .foregroundColor(AppColors.accentText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppColors.yellow)
                            .cornerRadius(25)
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
        }
    }
    
    private func completeOnboarding() {
        withAnimation(.easeOut(duration: 0.5)) {
            isOnboardingComplete = true
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
            
            Image(systemName: page.imageName)
                .font(.system(size: 100))
                .foregroundColor(AppColors.yellow)
                .shadow(color: AppColors.yellow.opacity(0.3), radius: 20, x: 0, y: 10)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(AppFonts.title1)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Text(page.description)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(isOnboardingComplete: .constant(false))
}
