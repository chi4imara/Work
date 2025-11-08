import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var showOnboarding: Bool
    
    private let pages = [
        OnboardingPage(
            image: "house.fill",
            title: "Clean Home. Clear Mind.",
            description: "Keeping your home tidy is easier when you have a plan."
        ),
        OnboardingPage(
            image: "calendar",
            title: "Daily & Weekly Tasks",
            description: "This app helps you organize cleaning tasks into daily and weekly routines. Assign chores to specific rooms, check them off as you complete them, and always know what's next."
        ),
        OnboardingPage(
            image: "checkmark.circle.fill",
            title: "Stay Organized",
            description: "Whether it's vacuuming the living room, wiping the dust in the bedroom, or cleaning the windows in the kitchen — everything is structured and easy to track. Your cleaning schedule becomes clear, your progress visible, and your home — consistently clean and comfortable."
        )
    ]
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.pureWhite : Color.pureWhite.opacity(0.4))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                .padding(.bottom, 30)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        showOnboarding = false
                    }
                }) {
                    Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                        .font(.customHeadline())
                        .foregroundColor(.primaryBlue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pureWhite)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
                .padding(.horizontal, 30)
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
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: page.image)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(.pureWhite)
                .padding(.bottom, 20)
            
            Text(page.title)
                .font(.customTitle())
                .foregroundColor(.pureWhite)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            Text(page.description)
                .font(.customBody())
                .foregroundColor(.pureWhite.opacity(0.9))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}

