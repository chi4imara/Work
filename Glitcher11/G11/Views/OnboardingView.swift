import SwiftUI

struct OnboardingView: View {
    @Binding var isFirstLaunch: Bool
    @State private var currentPage = 0
    
    let pages = [
        OnboardingPage(
            image: "sparkles",
            title: "Organize your jewelry by style",
            description: "Create a clean, personal catalog of your accessories. Sort each piece by style, add a type and notes, and keep your favorite looks easy to find."
        ),
        OnboardingPage(
            image: "square.grid.2x2",
            title: "Track all your jewelry",
            description: "Keep everything in one simple organizer built to match your sense of style. Never lose track of your favorite pieces again."
        )
    ]
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(maxHeight: .infinity)
                
                VStack(spacing: 30) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? ColorTheme.lightBlue : ColorTheme.secondaryText)
                                .frame(width: 8, height: 8)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage += 1
                            }
                        } else {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                isFirstLaunch = true
                                UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                            }
                        }
                    }) {
                        Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(ColorTheme.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(ColorTheme.buttonGradient)
                            .cornerRadius(25)
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(ColorTheme.cardGradient)
                    .frame(width: 150, height: 150)
                
                Image(systemName: page.image)
                    .font(.system(size: 60))
                    .foregroundColor(ColorTheme.lightBlue)
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.playfairDisplay(28, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.playfairDisplay(18))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct OnboardingPage {
    let image: String
    let title: String
    let description: String
}

#Preview {
    OnboardingView(isFirstLaunch: .constant(true))
}
