import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    @State private var bubbles: [MovingBubble] = []
    
    let pages = [
        OnboardingPage(
            title: "Collect Smiles That Find You",
            description: "This app helps you notice and remember spontaneous smiles — those small, warm moments that brighten ordinary days.",
            systemImage: "face.smiling"
        ),
        OnboardingPage(
            title: "Capture Joy Everywhere",
            description: "Write down when you saw someone smile, even if it was just for no reason. Each note is a tiny reminder that joy can appear anywhere, anytime.",
            systemImage: "heart.fill"
        ),
        OnboardingPage(
            title: "Track Your Happiness",
            description: "See how many smiles you've collected over time. Build a beautiful collection of positive moments that make your days brighter.",
            systemImage: "chart.line.uptrend.xyaxis"
        ),
        OnboardingPage(
            title: "Share Your Thoughts",
            description: "Keep a personal diary of your thoughts and reflections. Record what's on your mind and create a space for self-discovery.",
            systemImage: "lightbulb.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(bubbles, id: \.id) { bubble in
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: bubble.size, height: bubble.size)
                    .position(bubble.position)
                    .animation(.linear(duration: bubble.duration).repeatForever(autoreverses: false), value: bubble.position)
            }
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                HStack(spacing: 12) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? AppColors.yellow : AppColors.white.opacity(0.5))
                            .frame(width: 12, height: 12)
                            .scaleEffect(index == currentPage ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 30)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage += 1
                        }
                    } else {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showOnboarding = false
                        }
                    }
                }) {
                    HStack {
                        Text(currentPage < pages.count - 1 ? "Continue" : "Start Your Journey")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(AppColors.skyBlue)
                        
                        if currentPage < pages.count - 1 {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppColors.skyBlue)
                        } else {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppColors.skyBlue)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(AppColors.white)
                    .cornerRadius(28)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            generateBubbles()
        }
    }
    
    private func generateBubbles() {
        bubbles = (0..<12).map { _ in
            MovingBubble(
                id: UUID(),
                size: CGFloat.random(in: 30...80),
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: UIScreen.main.bounds.height + 100
                ),
                duration: Double.random(in: 10...20)
            )
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            for i in bubbles.indices {
                bubbles[i].position = CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: -100
                )
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.white.opacity(0.2))
                    .frame(width: 140, height: 140)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
                
                Image(systemName: page.systemImage)
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(AppColors.yellow)
                    .scaleEffect(isAnimating ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(0.5), value: isAnimating)
                    .rotationEffect(.degrees(isAnimating ? 5 : -5))
                    .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true).delay(1), value: isAnimating)
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 40)
            
            Spacer()
            Spacer()
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
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}

