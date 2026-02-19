import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var showOnboarding: Bool
    
    private let pages = [
        OnboardingPage(
            title: "Start Managing Your Purchases",
            description: "Plan purchases, control budget and track purchases — all in one app",
            imageName: "cart"
        ),
        OnboardingPage(
            title: "Create Your Categories",
            description: "Divide purchases by categories to see where money goes and which things bring joy",
            imageName: "square.grid.2x2"
        ),
        OnboardingPage(
            title: "Track Your Progress",
            description: "Monitor purchases, track budget, maintain collection of acquired items",
            imageName: "chart.line.uptrend.xyaxis"
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
                
                VStack(spacing: 30) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? Color.theme.primaryYellow : Color.theme.primaryWhite.opacity(0.4))
                                .frame(width: 10, height: 10)
                                .scaleEffect(index == currentPage ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
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
                        Text("Continue")
                            .font(FontManager.playfairSemiBold(size: 18))
                            .foregroundColor(Color.theme.darkBlue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.theme.primaryYellow)
                            .cornerRadius(28)
                            .shadow(color: Color.theme.primaryYellow.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -50 && currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage += 1
                        }
                    } else if value.translation.width > 50 && currentPage > 0 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage -= 1
                        }
                    }
                }
        )
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(Color.theme.primaryYellow)
                .shadow(color: Color.theme.primaryYellow.opacity(0.3), radius: 20, x: 0, y: 10)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(FontManager.playfairBold(size: 28))
                    .foregroundColor(Color.theme.primaryWhite)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(FontManager.playfairRegular(size: 16))
                    .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
