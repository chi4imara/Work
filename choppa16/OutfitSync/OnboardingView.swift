import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            AppGradients.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPage(
                        imageName: "tshirt.fill",
                        title: "Organize your wardrobe by season",
                        description: "Keep your clothing fresh and ready for every season. Plan what to buy, what to store, and what to keep wearing — all in one place."
                    )
                    .tag(0)
                    
                    OnboardingPage(
                        imageName: "list.bullet.clipboard.fill",
                        title: "Smart Shopping Lists",
                        description: "Add notes, track your wardrobe by categories, and prepare smoothly for every seasonal change."
                    )
                    .tag(1)
                    
                    OnboardingPage(
                        imageName: "sparkles",
                        title: "Simple & Practical",
                        description: "Simple, practical, and built for your style routine. Get started and transform your wardrobe organization today."
                    )
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(currentPage == index ? Color.primaryPurple : Color.textSecondary.opacity(0.3))
                            .frame(width: 10, height: 10)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 30)
                
                Button(action: {
                    if currentPage < 2 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage += 1
                        }
                    } else {
        
                        UserDefaults.standard.set(true, forKey: "has_completed_onboarding")
                        withAnimation(.easeInOut(duration: 0.5)) {
                            hasCompletedOnboarding = true
                        }
                    }
                }) {
                    Text(currentPage < 2 ? "Continue" : "Get Started")
                        .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                        .foregroundColor(.textOnDark)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.primaryPurple)
                                .shadow(color: AppShadows.buttonShadow, radius: 8, x: 0, y: 4)
                        )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage: View {
    let imageName: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(.primaryPurple)
                .padding(.bottom, 20)
            
            VStack(spacing: 20) {
                Text(title)
                    .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Text(description)
                    .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}
