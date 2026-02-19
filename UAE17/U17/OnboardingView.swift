import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            title: "Master your garage inventory",
            description: "This app helps you organize your garage tools by tracking what you own, where each item is stored, and when it was last used.",
            imageName: "wrench.and.screwdriver.fill"
        ),
        OnboardingPage(
            title: "Track Everything",
            description: "Add tools with full details, update usage with one tap, browse the entire collection, and keep your workspace structured.",
            imageName: "list.clipboard.fill"
        ),
        OnboardingPage(
            title: "Stay Organized",
            description: "Manage your tools efficiently every day with smart categorization, search functionality, and usage statistics.",
            imageName: "chart.bar.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack(spacing: 12) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.theme.orange : Color.theme.white.opacity(0.3))
                            .frame(width: 12, height: 12)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 40)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage += 1
                        }
                    } else {
                        showOnboarding = false
                    }
                }) {
                    Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(Color.theme.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.theme.orange)
                        )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
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
                .foregroundColor(Color.theme.lightBlue)
                .padding(.bottom, 20)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.playfairDisplay(32, weight: .bold))
                    .foregroundColor(Color.theme.white)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(Color.theme.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
