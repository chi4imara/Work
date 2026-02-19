import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appViewModel: AppViewModel
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    let pages = [
        OnboardingPage(
            title: "Organize your gadget collection",
            description: "Create a clear catalog of your devices with purchase dates, prices and condition notes. Track how long each gadget has been used and keep your collection structured.",
            systemImage: "iphone.and.arrow.forward"
        ),
        OnboardingPage(
            title: "Track Everything",
            description: "A simple way to remember important details and maintain order in your tech lineup. Never forget when you bought something or how much you paid.",
            systemImage: "list.bullet.clipboard"
        ),
        OnboardingPage(
            title: "Stay Organized",
            description: "Group your devices by categories, monitor their condition, and keep all important information in one place.",
            systemImage: "folder.badge.gearshape"
        )
    ]
    
    var body: some View {
        ZStack {
            Color.theme.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index], isAnimating: isAnimating)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                VStack(spacing: 30) {
                    HStack(spacing: 12) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.theme.orange : Color.theme.lightBlue.opacity(0.3))
                                .frame(width: 10, height: 10)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentPage += 1
                            }
                        } else {
                            appViewModel.completeOnboarding()
                        }
                    }) {
                        HStack {
                            Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                                .font(.playfairDisplay(size: 18, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color.theme.primaryText)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Color.theme.accentGradient)
                        )
                        .scaleEffect(isAnimating ? 1.05 : 1.0)
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                isAnimating = true
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
    let isAnimating: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.systemImage)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(Color.theme.lightBlue)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.playfairDisplay(size: 32, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(.playfairDisplay(size: 16, weight: .regular))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    OnboardingView(appViewModel: AppViewModel())
}
