import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appViewModel: AppViewModel
    @State private var currentPage = 0
    
    private let onboardingData = [
        OnboardingPage(
            title: "Master your BBQ recipes",
            description: "Keep all your BBQ ideas in one place. Save recipes, grilling times, sauces and favorite combinations.",
            imageName: "flame.fill"
        ),
        OnboardingPage(
            title: "Organize by meat types",
            description: "Build your personal barbecue organizer with clear notes and easy access to every dish.",
            imageName: "list.bullet.clipboard.fill"
        ),
        OnboardingPage(
            title: "Stay prepared",
            description: "Stay prepared for any cookout with your own structured collection of BBQ recipes and techniques.",
            imageName: "checkmark.circle.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            ColorManager.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingData.count, id: \.self) { index in
                        OnboardingPageView(page: onboardingData[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(maxHeight: .infinity)
                
                VStack(spacing: 20) {
                    HStack(spacing: 8) {
                        ForEach(0..<onboardingData.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? ColorManager.orange : ColorManager.primaryText.opacity(0.3))
                                .frame(width: 10, height: 10)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < onboardingData.count - 1 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage += 1
                            }
                        } else {
                            appViewModel.completeOnboarding()
                        }
                    }) {
                        Text(currentPage == onboardingData.count - 1 ? "Get Started" : "Continue")
                            .font(.playfairDisplay(size: 18, weight: .semibold))
                            .foregroundColor(ColorManager.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(ColorManager.accentGradient)
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
            
            Image(systemName: page.imageName)
                .font(.system(size: 80))
                .foregroundColor(ColorManager.orange)
                .padding(.bottom, 20)
            
            Text(page.title)
                .font(.playfairDisplay(size: 32, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            Text(page.description)
                .font(.playfairDisplay(size: 18, weight: .regular))
                .foregroundColor(ColorManager.secondaryText)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(appViewModel: AppViewModel())
}
