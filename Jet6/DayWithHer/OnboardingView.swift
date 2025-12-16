import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    
    private let totalPages = 3
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                OnboardingPageView(
                    imageName: "heart.circle.fill",
                    title: "Cherish every plan",
                    subtitle: "create lasting memories",
                    description: "Keep every shared moment with your friends in one cozy place. Write down your ideas — from spontaneous coffee breaks to weekend trips or cozy nights in.",
                    currentPage: $currentPage,
                    pageIndex: 0,
                    totalPages: totalPages,
                    showOnboarding: $showOnboarding
                )
                .tag(0)
                
                OnboardingPageView(
                    imageName: "calendar.circle.fill",
                    title: "Plan & Remember",
                    subtitle: "your special moments",
                    description: "Mark what you've already done and see how your friendship grows through the memories you collect. Each idea becomes a story: a picnic that turned into laughter, a photoshoot under the sunset.",
                    currentPage: $currentPage,
                    pageIndex: 1,
                    totalPages: totalPages,
                    showOnboarding: $showOnboarding
                )
                .tag(1)
                
                OnboardingPageView(
                    imageName: "star.circle.fill",
                    title: "Create Beautiful",
                    subtitle: "memories together",
                    description: "This app helps you plan, remember, and relive every beautiful moment — together. A simple walk that felt special, or a cozy evening that became unforgettable.",
                    currentPage: $currentPage,
                    pageIndex: 2,
                    totalPages: totalPages,
                    showOnboarding: $showOnboarding
                )
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
    }
}

struct OnboardingPageView: View {
    let imageName: String
    let title: String
    let subtitle: String
    let description: String
    @Binding var currentPage: Int
    let pageIndex: Int
    let totalPages: Int
    @Binding var showOnboarding: Bool
    
    private var isLastPage: Bool {
        pageIndex == totalPages - 1
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: imageName)
                .font(.system(size: 80))
                .foregroundColor(AppColors.blueText)
                .padding(.bottom, 20)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.playfair(size: 32, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(.playfair(size: 24, weight: .medium))
                    .foregroundColor(AppColors.blueText)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            
            Text(description)
                .font(.playfair(size: 16, weight: .regular))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 40)
            
            Spacer()
            
            Button(action: {
                if isLastPage {
                    UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showOnboarding = false
                    }
                } else {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentPage = pageIndex + 1
                    }
                }
            }) {
                Text("Continue")
                    .font(.playfair(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(AppColors.purpleGradient)
                    .cornerRadius(25)
                    .shadow(color: AppColors.primaryPurple.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
