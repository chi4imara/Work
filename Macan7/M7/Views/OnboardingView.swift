import SwiftUI

struct OnboardingView: View {
    let onComplete: () -> Void
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            image: "camera.on.rectangle",
            title: "Plan your perfect photoshoot",
            description: "Turn your creative ideas into structured photoshoot plans. Add themes, locations, poses, and props — everything you need for a complete session outline."
        ),
        OnboardingPage(
            image: "list.clipboard",
            title: "Stay organized",
            description: "Keep track of what's been done, what's still planned, and never lose another idea. From first sketch to finished shot, every concept stays organized in one simple app."
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
                
                VStack(spacing: 24) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.appPrimary : Color.appLightGray)
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
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
                        Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.appPrimary)
                            )
                    }
                    .padding(.horizontal, 40)
                    
                    if currentPage == 0 {
                        Button(action: {
                            onComplete()
                        }) {
                            Text("Skip")
                                .font(.ubuntu(16))
                                .foregroundColor(.appSecondaryText)
                        }
                    }
                }
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage {
    let image: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.image)
                .font(.system(size: 120))
                .foregroundColor(.appPrimary)
                .padding(.bottom, 20)
            
            VStack(spacing: 12) {
                Text(page.title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(.appPrimaryText)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.ubuntu(14))
                    .foregroundColor(.appSecondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(onComplete: {})
}
