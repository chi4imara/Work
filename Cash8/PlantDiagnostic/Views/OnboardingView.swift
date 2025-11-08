import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            image: "leaf.fill",
            title: "Grow Smarter. Care Easier.",
            description: "This app is your personal guide to plant care — from houseplants on your windowsill to flowers and trees in your garden."
        ),
        OnboardingPage(
            image: "drop.fill",
            title: "Perfect Care Instructions",
            description: "Every plant has its needs: some thrive on bright sunlight, others prefer shade; some require frequent watering, while others suffer from too much care."
        ),
        OnboardingPage(
            image: "stethoscope",
            title: "Smart Diagnostics",
            description: "The built-in symptom checker helps you quickly identify problems and find solutions. Each entry gives you step-by-step instructions for optimal plant health."
        )
    ]
    
    var body: some View {
        ZStack {
            AppGradients.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(maxHeight: .infinity)
                
                VStack(spacing: 20) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.accentGreen : Color.gray.opacity(0.3))
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
                            appState.completeOnboarding()
                        }
                    }) {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(.buttonText)
                            .foregroundColor(.buttonText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(AppGradients.buttonGradient)
                            .cornerRadius(25)
                    }
                    .padding(.horizontal, 40)
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
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: page.image)
                .font(.system(size: 80))
                .foregroundColor(.accentGreen)
                .padding(.bottom, 20)
            
            Text(page.title)
                .font(.titleLarge)
                .foregroundColor(.primaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Text(page.description)
                .font(.bodyLarge)
                .foregroundColor(.primaryText)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
}

