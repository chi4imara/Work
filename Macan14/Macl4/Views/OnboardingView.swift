import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var showOnboarding: Bool
    @EnvironmentObject private var appStateManager: AppStateManager
    
    let pages = [
        OnboardingPage(
            title: "Keep track of your favorite stores",
            description: "Turn your shopping experience into an organized personal catalog.",
            systemImage: "bag.fill"
        ),
        OnboardingPage(
            title: "Organize Your Shopping",
            description: "This app helps you keep a clear overview of all the stores you love — from cozy local boutiques to your go-to online shops.",
            systemImage: "square.grid.2x2.fill"
        ),
        OnboardingPage(
            title: "Add & Categorize",
            description: "Add each store with just a few taps: write its name, category, and price level, and leave a short note about your impressions.",
            systemImage: "plus.circle.fill"
        ),
        OnboardingPage(
            title: "Filter & Discover",
            description: "Filter your list by category or type — clothing, cosmetics, accessories, or home — and quickly find the perfect place for your next purchase.",
            systemImage: "line.3.horizontal.decrease.circle.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
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
                                .fill(currentPage == index ? Color.appAccent : Color.appPrimary.opacity(0.3))
                                .frame(width: 10, height: 10)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    .padding(.top, 20)
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentPage += 1
                            }
                        } else {
                            appStateManager.completeOnboarding()
                        }
                    }) {
                        Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                LinearGradient(
                                    colors: [Color.appPrimary, Color.appAccent],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(25)
                            .shadow(color: Color.appShadow, radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                }
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
    @State private var animateIcon = false
    @State private var animateText = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.appAccent.opacity(0.3),
                                Color.appPrimary.opacity(0.1)
                            ],
                            center: .center,
                            startRadius: 20,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                    .scaleEffect(animateIcon ? 1.0 : 0.8)
                
                Image(systemName: page.systemImage)
                    .font(.system(size: 60, weight: .medium))
                    .foregroundColor(Color.appPrimary)
                    .scaleEffect(animateIcon ? 1.0 : 0.5)
            }
            .animation(.spring(response: 0.8, dampingFraction: 0.6), value: animateIcon)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(Color.appText)
                    .multilineTextAlignment(.center)
                    .opacity(animateText ? 1.0 : 0.0)
                    .offset(y: animateText ? 0 : 20)
                
                Text(page.description)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(Color.appTextSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .opacity(animateText ? 1.0 : 0.0)
                    .offset(y: animateText ? 0 : 30)
            }
            .padding(.horizontal, 40)
            .animation(.easeOut(duration: 0.8).delay(0.3), value: animateText)
            
            Spacer()
        }
        .onAppear {
            animateIcon = true
            animateText = true
        }
        .onDisappear {
            animateIcon = false
            animateText = false
        }
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
