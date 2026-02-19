import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            image: "tshirt.fill",
            title: "Your ready-to-wear outfit sets.",
            description: "Create and save complete outfit sets with clothing, shoes, and accessories that work perfectly together."
        ),
        OnboardingPage(
            image: "camera.fill",
            title: "Capture your style",
            description: "Add photos, name each set, and leave short notes about when it fits best."
        ),
        OnboardingPage(
            image: "heart.fill",
            title: "Your personal reference",
            description: "Over time, this organizer becomes a practical reference for choosing ready-made looks with confidence."
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 400)
                
                Spacer()
                
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.primaryYellow : Color.textSecondary.opacity(0.3))
                            .frame(width: 10, height: 10)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 20)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.spring()) {
                            currentPage += 1
                        }
                    } else {
                        showOnboarding = true
                        UserDefaultsManager.shared.hasSeenOnboarding = true
                    }
                }) {
                    Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                        .font(.lumierepolis(18, weight: .bold))
                        .foregroundColor(.textDark)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.primaryYellow)
                        )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
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
            ZStack {
                Circle()
                    .fill(Color.primaryYellow.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: page.image)
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.primaryYellow)
            }
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.lumierepolis(28, weight: .bold))
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.lumierepolis(16, weight: .light))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 30)
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
