import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            icon: "figure.hiking",
            title: "Your outdoor trip journal.",
            description: "Save your hiking and fishing trips with clear details. Record dates, routes, locations and personal notes to build a structured outdoor journal.",
            color: Color.lightBlue
        ),
        OnboardingPage(
            icon: "location.circle",
            title: "Keep track of adventures",
            description: "Keep your experiences organized and revisit your favorite adventures anytime. Never forget the details of your best outdoor moments.",
            color: Color.brightOrange
        ),
        OnboardingPage(
            icon: "book.closed",
            title: "Build your history",
            description: "Create categories, add detailed notes, and build a comprehensive history of all your outdoor activities in one convenient place.",
            color: Color.softGreen
        )
    ]
    
    var body: some View {
        ZStack {
            GradientBackground()
            
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
                            .fill(currentPage == index ? Color.pureWhite : Color.pureWhite.opacity(0.3))
                            .frame(width: 10, height: 10)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.vertical, 20)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    } else {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showOnboarding = false
                        }
                    }
                }) {
                    Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(.darkBlue)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.pureWhite)
                        .cornerRadius(28)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: page.icon)
                    .font(.system(size: 50))
                    .foregroundColor(page.color)
            }
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(.pureWhite)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(.pureWhite.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
