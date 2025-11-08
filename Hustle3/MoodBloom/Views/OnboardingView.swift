import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var opacity: Double = 0
    var onComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            title: "Your mood. Your diary.",
            description: "Every day tells a story — your emotions shape how you live, decide, and feel. This app helps you capture those moments with a simple smile and a short note.",
            imageName: "heart.circle.fill"
        ),
        OnboardingPage(
            title: "Track Your Journey",
            description: "Open the calendar, choose the emoji that reflects your state — joy, calm, stress, or fatigue — and add a thought in your own words. Over time, you'll see a clear picture of your emotional journey.",
            imageName: "calendar.circle.fill"
        ),
        OnboardingPage(
            title: "Discover Patterns",
            description: "The main screen shows your mood calendar and recent notes, while the analytics view reveals patterns: how your feelings change by days, weeks, or months. A dedicated space for personal notes lets you write down reflections that don't fit into the calendar.",
            imageName: "chart.line.uptrend.xyaxis.circle.fill"
        ),
        OnboardingPage(
            title: "Stay Connected",
            description: "No clutter, no pressure — just a clean and thoughtful way to stay connected with yourself, track your balance, and notice how your well-being evolves.",
            imageName: "leaf.circle.fill"
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
                
                VStack(spacing: 20) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.primaryBlue : Color.textSecondary.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    .padding(.bottom, 10)
                    
                    HStack(spacing: 16) {
                        if currentPage > 0 {
                            Button("Back") {
                                withAnimation(.easeInOut) {
                                    currentPage -= 1
                                }
                            }
                            .font(FontManager.body)
                            .foregroundColor(Color.textSecondary)
                        }
                        
                        Spacer()
                        
                        Button(currentPage == pages.count - 1 ? "Get Started" : "Continue") {
                            if currentPage == pages.count - 1 {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    opacity = 0
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    onComplete()
                                }
                            } else {
                                withAnimation(.easeInOut) {
                                    currentPage += 1
                                }
                            }
                        }
                        .font(FontManager.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.primaryBlue, Color.darkBlue]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                        .shadow(color: Color.primaryBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 32)
                }
                .padding(.bottom, 50)
            }
        }
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
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
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(Color.primaryBlue)
                .padding(.bottom, 20)
            
            Text(page.title)
                .font(FontManager.title)
                .foregroundColor(Color.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Text(page.description)
                .font(FontManager.body)
                .foregroundColor(Color.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 32)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
