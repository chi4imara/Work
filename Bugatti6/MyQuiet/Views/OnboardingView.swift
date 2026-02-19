import SwiftUI

struct OnboardingView: View {
    let onComplete: () -> Void
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    private let pages = [
        OnboardingPage(
            title: "Capture the principles you live by.",
            description: "This app helps you write down personal principles that guide your actions and decisions.",
            systemImage: "quote.bubble.fill",
            color: Color.appTextBlue
        ),
        OnboardingPage(
            title: "Keep them organized",
            description: "You create short, clear statements and keep them in one place for easy reference.",
            systemImage: "list.bullet.rectangle",
            color: Color.appAccentYellow
        ),
        OnboardingPage(
            title: "Focus on what matters",
            description: "No explanations or motivation — just a focused list of principles that reflect how you choose to live and act.",
            systemImage: "target",
            color: Color.appSoftPurple
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GridPattern()
                .opacity(0.2)
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index], isAnimating: $isAnimating)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 30) {
                    HStack(spacing: 12) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.appTextBlue : Color.gray)
                                .frame(width: 10, height: 10)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    HStack {
                        if currentPage > 0 {
                            Button("Back") {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentPage -= 1
                                }
                            }
                            .font(.playfairDisplay(16, weight: .medium))
                            .foregroundColor(Color.appTextBlue)
                            .frame(maxWidth: .infinity)
                        }
                        
                        Button {
                            if currentPage == pages.count - 1 {
                                onComplete()
                            } else {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentPage += 1
                                }
                            }
                        } label: {
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                                .font(.playfairDisplay(18, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 15)
                                .frame(maxWidth: .infinity)
                                .background(AppColors.buttonGradient)
                                .cornerRadius(25)
                                .shadow(color: Color.appTextBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let systemImage: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @Binding var isAnimating: Bool
    @State private var imageScale: CGFloat = 0.5
    @State private var textOpacity: Double = 0.0
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: page.systemImage)
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(page.color)
            }
            .scaleEffect(imageScale)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.playfairDisplay(28, weight: .bold))
                    .foregroundColor(Color.appTextBlue)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(Color.appDarkGray)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 40)
            .opacity(textOpacity)
            
            Spacer()
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                imageScale = 1.0
            }
            
            withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
                textOpacity = 1.0
            }
        }
    }
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
