import SwiftUI

struct OnboardingView: View {
    @ObservedObject var catalogViewModel: CatalogViewModel
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            title: "A personal catalog of taste.",
            description: "This app helps you collect things you like as simple entries: scents, color combinations, words, place names, or images you enjoy.",
            imageName: "heart.circle.fill"
        ),
        OnboardingPage(
            title: "Simple and Personal",
            description: "You just write them down and save them without sorting or explaining why. Over time, your catalog becomes a quiet record of your personal taste.",
            imageName: "book.circle.fill"
        ),
        OnboardingPage(
            title: "No Judgments",
            description: "There are no categories, ratings, or explanations needed. Just capture what resonates with you in the moment, exactly as you experience it.",
            imageName: "sparkles"
        ),
        OnboardingPage(
            title: "Your Collection Grows",
            description: "Each entry becomes part of your unique collection. Discover patterns, revisit memories, and see your personal taste evolve over time.",
            imageName: "star.circle.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
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
                            .fill(currentPage == index ? AppColors.accent : AppColors.primaryText.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut) {
                            currentPage += 1
                        }
                    } else {
                        catalogViewModel.completeOnboarding()
                    }
                }) {
                    Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(AppColors.buttonText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(AppColors.buttonBackground)
                        )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 30) {
            if let imageName = page.imageName {
                Image(systemName: imageName)
                    .font(.system(size: 80))
                    .foregroundColor(AppColors.accent)
            }
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    OnboardingView(catalogViewModel: CatalogViewModel())
}
