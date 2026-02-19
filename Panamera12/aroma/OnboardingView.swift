import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: FragranceViewModel
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    private let pages = [
        OnboardingPage(
            title: "Choose the right scent with ease.",
            description: "Create a personal archive of your fragrances with notes, seasons, and usage occasions.",
            systemImage: "sparkles"
        ),
        OnboardingPage(
            title: "Stay Organized",
            description: "Keep everything clearly organized, quickly recall what you own, and select the perfect scent for each event without hesitation.",
            systemImage: "square.grid.3x3"
        ),
        OnboardingPage(
            title: "Make Confident Choices",
            description: "A simple way to make confident fragrance choices every day.",
            systemImage: "checkmark.circle"
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
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
                    HStack(spacing: 12) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? Color.appPrimaryYellow : Color.appPrimaryBlue.opacity(0.3))
                                .frame(width: 12, height: 12)
                                .scaleEffect(index == currentPage ? 1.2 : 1.0)
                                .animation(.spring(response: 0.3), value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentPage += 1
                            }
                        } else {
                            viewModel.completeOnboarding()
                        }
                    }) {
                        HStack {
                            Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                                .font(.bauhausMedium(18))
                                .foregroundColor(.white)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 28)
                                .fill(AppColors.buttonGradient)
                        )
                        .shadow(color: Color.appPrimaryYellow.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 40)
                    .scaleEffect(isAnimating ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            isAnimating = true
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
            
            ZStack {
                Circle()
                    .fill(Color.appLightBlue.opacity(0.3))
                    .frame(width: 150, height: 150)
                    .scaleEffect(isAnimating ? 1.1 : 0.9)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                
                Image(systemName: page.systemImage)
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(.appPrimaryBlue)
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true).delay(0.2), value: isAnimating)
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.bauhausBold(28))
                    .foregroundColor(.appPrimaryBlue)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(.bauhausLight(16))
                    .foregroundColor(.appTextGray)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(viewModel: FragranceViewModel())
}
