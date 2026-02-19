import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appState: AppState
    @State private var currentPage = 0
    @State private var opacity: Double = 0
    
    let pages = [
        OnboardingPage(
            title: "Create your perfect jewelry sets",
            description: "Build a personal catalog of your jewelry and accessories, keep everything organized, and create sets for different outfits and occasions.",
            imageName: "sparkles"
        ),
        OnboardingPage(
            title: "Organize with confidence",
            description: "Quickly see what you own, combine pieces with confidence, and choose the right accessories without second guessing your look.",
            imageName: "star.circle"
        ),
        OnboardingPage(
            title: "Track your collection",
            description: "Add photos, notes, and details for each piece. Know exactly what you have and where everything is stored.",
            imageName: "photo.stack"
        ),
        OnboardingPage(
            title: "Plan your outfits",
            description: "Create sets for different occasions and styles. Mix and match your jewelry to create the perfect look every time.",
            imageName: "square.stack.3d.up"
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
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? ColorTheme.accentYellow : ColorTheme.primaryText.opacity(0.3))
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
                            appState.completeOnboarding()
                        }
                    }) {
                        HStack {
                            Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                                .font(.lumierepolis(18, weight: .bold))
                                .foregroundColor(ColorTheme.buttonText)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .foregroundColor(ColorTheme.buttonText)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(ColorTheme.buttonPrimary)
                        .cornerRadius(25)
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
        }
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeIn(duration: 0.8)) {
                opacity = 1
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
    @State private var imageScale: CGFloat = 0.8
    @State private var textOpacity: Double = 0
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorTheme.accentYellow)
                .scaleEffect(imageScale)
                .onAppear {
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2)) {
                        imageScale = 1.0
                    }
                    withAnimation(.easeIn(duration: 0.8).delay(0.4)) {
                        textOpacity = 1
                    }
                }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.lumierepolis(28, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(.lumierepolis(16))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 40)
            .opacity(textOpacity)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(appState: AppState())
}
