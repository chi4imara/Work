import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var dragOffset: CGSize = .zero
    
    let onComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            title: "Discover the World",
            description: "Plan trips, walks, and leisure activities. Capture your favorite places and experiences.",
            systemImage: "globe.americas.fill"
        ),
        OnboardingPage(
            title: "Small Steps - Big Discoveries",
            description: "Create 'Want to Visit' and 'Done' lists, participate in mini-challenges.",
            systemImage: "map.fill"
        ),
        OnboardingPage(
            title: "Let's Start Exploring",
            description: "Daily tasks, visual rewards, and micro-support will help you enjoy traveling.",
            systemImage: "star.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Capsule()
                            .fill(index == currentPage ? Color.primaryYellow : Color.primaryBlue.opacity(0.3))
                            .frame(width: index == currentPage ? 24 : 8, height: 8)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.top, 60)
                .padding(.horizontal, 20)
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 20) {
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage += 1
                            }
                        } else {
                            onComplete()
                        }
                    }) {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(.playfairDisplay(.semibold, size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.primaryYellow)
                                    .shadow(color: Color.primaryYellow.opacity(0.3), radius: 8, x: 0, y: 4)
                            )
                    }
                    .padding(.horizontal, 40)
                    
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            onComplete()
                        }
                        .font(.playfairDisplay(.medium, size: 16))
                        .foregroundColor(.primaryBlue)
                    }
                }
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var isAnimated = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.primaryYellow.opacity(0.2))
                    .frame(width: 200, height: 200)
                    .scaleEffect(isAnimated ? 1.1 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true),
                        value: isAnimated
                    )
                
                Image(systemName: page.systemImage)
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(.primaryBlue)
                    .scaleEffect(isAnimated ? 1.05 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true),
                        value: isAnimated
                    )
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.playfairDisplay(.bold, size: 32))
                    .foregroundColor(.primaryBlue)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(.playfairDisplay(.regular, size: 18))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .onAppear {
            isAnimated = true
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
    }
}
