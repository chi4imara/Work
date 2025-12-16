import SwiftUI

struct OnboardingView: View {
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var colorTheme = ColorTheme.shared
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            TabView(selection: $currentPage) {
                OnboardingPage(
                    title: "Color Your Mood Each Day",
                    description: "This app helps you connect with your mood through colors. Every day, choose a shade that feels right for you — the color that matches your energy, thoughts, or emotions.",
                    imageName: "paintpalette",
                    currentPage: $currentPage,
                    isLastPage: false
                )
                .tag(0)
                
                OnboardingPage(
                    title: "Express Your Feelings",
                    description: "Write a few words about why you chose it. Was it a calm blue day, a passionate red, or a gentle green?",
                    imageName: "pencil.and.outline",
                    currentPage: $currentPage,
                    isLastPage: false
                )
                .tag(1)
                
                OnboardingPage(
                    title: "Track Your Journey",
                    description: "Over time, your palette will grow — a gallery of moods that shows how your inner world changes, one color at a time.",
                    imageName: "chart.line.uptrend.xyaxis",
                    currentPage: $currentPage,
                    isLastPage: true,
                    onComplete: {
                        dataManager.completeOnboarding()
                    }
                )
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentPage)
        }
    }
}

struct OnboardingPage: View {
    let title: String
    let description: String
    let imageName: String
    @Binding var currentPage: Int
    let isLastPage: Bool
    let onComplete: (() -> Void)?
    
    @StateObject private var colorTheme = ColorTheme.shared
    @State private var isAnimating = false
    
    init(title: String, description: String, imageName: String, currentPage: Binding<Int>, isLastPage: Bool, onComplete: (() -> Void)? = nil) {
        self.title = title
        self.description = description
        self.imageName = imageName
        self._currentPage = currentPage
        self.isLastPage = isLastPage
        self.onComplete = onComplete
    }
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(colorTheme.primaryWhite.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                
                Image(systemName: imageName)
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(colorTheme.primaryWhite)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
            }
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.playfairDisplay(28, weight: .bold))
                    .foregroundColor(colorTheme.primaryWhite)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text(description)
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(colorTheme.primaryWhite.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 30)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? colorTheme.primaryWhite : colorTheme.primaryWhite.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut, value: currentPage)
                }
            }
            .padding(.bottom, 20)
            
            Button(action: {
                if isLastPage {
                    onComplete?()
                } else {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentPage += 1
                    }
                }
            }) {
                HStack {
                    Text(isLastPage ? "Get Started" : "Continue")
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(colorTheme.primaryPurple)
                    
                    if !isLastPage {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(colorTheme.primaryPurple)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(colorTheme.primaryWhite)
                .cornerRadius(25)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    OnboardingView()
}
