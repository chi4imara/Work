import SwiftUI

struct OnboardingScreen: View {
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    let onComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            title: "Notice What Was Absent Today",
            description: "This app helps you build awareness through simple daily reflection.",
            systemImage: "leaf.circle.fill"
        ),
        OnboardingPage(
            title: "Track Your Progress",
            description: "Every evening, you record what didn't happen — no complaints, no rushing, no worries. Each note reminds you that peace is also progress.",
            systemImage: "chart.line.uptrend.xyaxis.circle.fill"
        ),
        OnboardingPage(
            title: "Build Awareness",
            description: "By tracking what was absent, you'll see the quiet growth of self-control and calm. It's not about perfection — it's about awareness. Every checkmark is a small victory of presence and patience.",
            systemImage: "brain.head.profile.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            ColorManager.shared.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(
                            page: pages[index],
                            isAnimating: isAnimating
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                VStack(spacing: 30) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? ColorManager.shared.primaryPurple : ColorManager.shared.lightGray)
                                .frame(width: 8, height: 8)
                                .scaleEffect(index == currentPage ? 1.2 : 1.0)
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
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(ColorManager.shared.primaryBlue)
                        }
                        
                        Spacer()
                        
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
                                .font(.ubuntu(16, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 12)
                                .background(
                                    LinearGradient(
                                        colors: [ColorManager.shared.primaryPurple, ColorManager.shared.primaryBlue],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(25)
                                .shadow(color: ColorManager.shared.primaryPurple.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                isAnimating = true
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let systemImage: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let isAnimating: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.systemImage)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorManager.shared.primaryPurple)
                .scaleEffect(isAnimating ? 1.0 : 0.5)
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.8).delay(0.2), value: isAnimating)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(ColorManager.shared.primaryBlue)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: isAnimating)
                
                Text(page.description)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.shared.darkGray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: isAnimating)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingScreen {
        print("Onboarding completed")
    }
}
