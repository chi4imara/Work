import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GridOverlay()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPageView(
                        imageName: "book.fill",
                        title: "Keep your recipes truly yours.",
                        description: "This app is a personal space for your own trusted recipes. Forget endless feeds and random ideas — here you collect only what you've tried, liked, and perfected."
                    )
                    .tag(0)
                    
                    OnboardingPageView(
                        imageName: "heart.fill",
                        title: "Your flavor, your way",
                        description: "Each recipe holds your exact steps, your flavor, and your way of cooking. Add, view, and refine your dishes anytime — simply, clearly, and without noise."
                    )
                    .tag(1)
                    
                    OnboardingPageView(
                        imageName: "house.fill",
                        title: "Your kitchen companion",
                        description: "Your recipes, your style, your kitchen companion. Start building your personal collection of perfect dishes today."
                    )
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(currentPage == index ? AppColors.primaryYellow : AppColors.primaryBlue.opacity(0.3))
                            .frame(width: 10, height: 10)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.vertical, 20)
                
                Button(action: {
                    if currentPage < 2 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage += 1
                        }
                    } else {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showOnboarding = false
                        }
                    }
                }) {
                    Text(currentPage < 2 ? "Continue" : "Get Started")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(AppColors.primaryBlue)
                        .cornerRadius(25)
                        .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPageView: View {
    let imageName: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryYellow)
                .frame(width: 120, height: 120)
                .background(
                    Circle()
                        .fill(AppColors.primaryBlue.opacity(0.1))
                )
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.primaryBlue)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Text(description)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.darkGray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 30)
            }
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
