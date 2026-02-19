import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: IdeasViewModel
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPageView(
                        imageName: "lightbulb.fill",
                        title: "One place for every idea.",
                        description: "This app lets you capture ideas the moment they appear — notes, plans, gift thoughts, projects, or fragments of text. You write freely, without folders or structure, and come back later using simple search. It's a clean space where nothing gets lost and every idea stays exactly as you wrote it.",
                        isAnimating: $isAnimating
                    )
                    .tag(0)
                    
                    OnboardingPageView(
                        imageName: "magnifyingglass",
                        title: "Find anything instantly",
                        description: "Use the powerful search to find any idea you've saved. No need to organize or categorize - just write and search when you need it.",
                        isAnimating: $isAnimating
                    )
                    .tag(1)
                    
                    OnboardingPageView(
                        imageName: "heart.fill",
                        title: "Simple and beautiful",
                        description: "Clean interface that gets out of your way. Focus on your ideas, not on complex features or overwhelming options.",
                        isAnimating: $isAnimating
                    )
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack(spacing: 12) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? AppColors.accentYellow : AppColors.primaryText.opacity(0.3))
                            .frame(width: 10, height: 10)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.vertical, 25)
                
                Button(action: {
                    if currentPage < 2 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage += 1
                        }
                    } else {
                        viewModel.completeOnboarding()
                    }
                }) {
                    Text(currentPage < 2 ? "Continue" : "Get Started")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(AppColors.buttonText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(AppColors.buttonBackground)
                        .cornerRadius(28)
                        .shadow(color: AppColors.accentYellow.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct OnboardingPageView: View {
    let imageName: String
    let title: String
    let description: String
    @Binding var isAnimating: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.accentYellow.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .scaleEffect(isAnimating ? 1.0 : 0.8)
                    .animation(
                        Animation.easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                
                Image(systemName: imageName)
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(AppColors.accentYellow)
                    .scaleEffect(isAnimating ? 1.1 : 0.9)
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
            }
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}
