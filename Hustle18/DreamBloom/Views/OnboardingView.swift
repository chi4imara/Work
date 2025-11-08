import SwiftUI

struct OnboardingView: View {
    @ObservedObject var dreamStore: DreamStore
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            title: "Record. Tag. Understand.",
            description: "Dreams often slip away the moment you wake up — but not anymore. This app is your personal dream journal, built to capture the fragments of your night and turn them into an organized collection.",
            systemImage: "moon.stars.fill"
        ),
        OnboardingPage(
            title: "Organize Your Dreams",
            description: "Every morning, you can open the app and write down your dream: just the date, a short or long description, and tags that describe the mood — scary, funny, vivid, or even your own custom tags.",
            systemImage: "tag.fill"
        ),
        OnboardingPage(
            title: "Discover Patterns",
            description: "Over weeks and months, you'll notice patterns: recurring places, emotions, or types of dreams that shape your nights. The tag system makes your journal searchable and structured.",
            systemImage: "chart.bar.fill"
        ),
        OnboardingPage(
            title: "Keep What Matters",
            description: "For the dreams that feel especially important, mark them as Favorites — they'll always be just one tap away. It's simple, private, and deeply personal. Because every dream tells a story — and now, it won't be forgotten.",
            systemImage: "heart.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                VStack(spacing: 20) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.dreamYellow : Color.dreamWhite.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    .padding(.bottom, 10)
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentPage += 1
                            }
                        } else {
                            dreamStore.completeOnboarding()
                        }
                    }) {
                        HStack {
                            Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                                .font(.dreamSubheadline)
                                .foregroundColor(.black)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.black)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.dreamYellow)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 40)
                    
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            dreamStore.completeOnboarding()
                        }
                        .font(.dreamBody)
                        .foregroundColor(.dreamWhite.opacity(0.7))
                        .padding(.top, 8)
                    }
                }
                .padding(.bottom, 50)
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
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: page.systemImage)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(.dreamYellow)
                .padding(.bottom, 20)
            
            Text(page.title)
                .font(.dreamTitle)
                .foregroundColor(.dreamWhite)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Text(page.description)
                .font(.dreamBody)
                .foregroundColor(.dreamWhite.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(dreamStore: DreamStore())
}
