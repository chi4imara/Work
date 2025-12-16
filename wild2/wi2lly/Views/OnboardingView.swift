import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var opacity = 0.0
    
    var onComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            title: "Collect Rare Words",
            description: "Discover and save unique, meaningful words that inspire you",
            systemImage: "book.fill"
        ),
        OnboardingPage(
            title: "Build Your Dictionary",
            description: "Organize words by categories and add personal notes to create your own reference",
            systemImage: "square.grid.3x3.fill"
        ),
        OnboardingPage(
            title: "Track Your Progress",
            description: "Watch your collection grow and see statistics about your word journey",
            systemImage: "chart.pie.fill"
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
                                .fill(index == currentPage ? Color.theme.primaryYellow : Color.theme.primaryBlue.opacity(0.3))
                                .frame(width: 12, height: 12)
                                .scaleEffect(index == currentPage ? 1.2 : 1.0)
                                .animation(.spring(response: 0.3), value: currentPage)
                        }
                    }
                    
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
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                                .font(.playfair(18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Color.theme.primaryBlue, Color.theme.darkBlue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(25)
                        .shadow(color: Color.theme.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
        }
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                opacity = 1.0
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var imageScale = 0.8
    @State private var textOpacity = 0.0
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.theme.primaryYellow.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: page.systemImage)
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(Color.theme.primaryBlue)
            }
            .scaleEffect(imageScale)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.playfair(32, weight: .bold))
                    .foregroundColor(Color.theme.primaryBlue)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.playfair(18, weight: .regular))
                    .foregroundColor(Color.theme.textGray)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 30)
            }
            .opacity(textOpacity)
            
            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2)) {
                imageScale = 1.0
            }
            
            withAnimation(.easeInOut(duration: 0.8).delay(0.4)) {
                textOpacity = 1.0
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let systemImage: String
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
