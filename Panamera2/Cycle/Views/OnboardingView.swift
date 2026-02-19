import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPage(
                        icon: "sparkles",
                        title: "Track every jewelry choice.",
                        description: "Create a simple organizer for your earrings, bracelets, and other accessories. Add your pieces, mark the last time you wore each one, and keep your looks fresh by avoiding repeats.",
                        pageIndex: 0,
                        currentPage: $currentPage
                    )
                    .tag(0)
                    
                    OnboardingPage(
                        icon: "heart.circle.fill",
                        title: "Organize with ease.",
                        description: "Categorize your jewelry collection and quickly find what you're looking for. Create custom categories that match your personal style and preferences.",
                        pageIndex: 1,
                        currentPage: $currentPage
                    )
                    .tag(1)
                    
                    OnboardingPage(
                        icon: "clock.fill",
                        title: "Never repeat outfits.",
                        description: "Keep track of when you last wore each piece. Build an easy system that helps you rotate your favorites with confidence and always look fresh.",
                        pageIndex: 2,
                        currentPage: $currentPage
                    )
                    .tag(2)
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                Button(action: {
                    if currentPage < 2 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showOnboarding = true
                            UserDefaults.standard.set(true, forKey: "HasSeenOnboarding")
                        }
                    }
                }) {
                    Text(currentPage < 2 ? "Continue" : "Get Started")
                        .font(.bauhausBold(size: 18))
                        .foregroundColor(AppColors.buttonText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(AppColors.buttonBackground)
                                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                        )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage: View {
    let icon: String
    let title: String
    let description: String
    let pageIndex: Int
    @Binding var currentPage: Int
    
    var isActive: Bool {
        currentPage == pageIndex
    }
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 100, weight: .light))
                .foregroundColor(AppColors.accentYellow)
                .scaleEffect(isActive ? 1.0 : 0.9)
                .animation(.spring(response: 0.6, dampingFraction: 0.6), value: isActive)
            
            VStack(spacing: 24) {
                Text(title)
                    .font(.bauhausBold(size: 32))
                    .foregroundColor(AppColors.primaryWhite)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                Text(description)
                    .font(.bauhausRegular(size: 16))
                    .foregroundColor(AppColors.primaryWhite.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
