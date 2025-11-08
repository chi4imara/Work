import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: InteriorIdeasViewModel
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    private let pages = [
        OnboardingPage(
            icon: "house.fill",
            title: "Design Your Space",
            subtitle: "Collect Your Ideas",
            description: "Great interiors start with inspiration. This app helps you capture every idea for your apartment design, from furniture choices to color palettes and decorative details."
        ),
        OnboardingPage(
            icon: "note.text",
            title: "Organize & Categorize",
            subtitle: "Your Design Vision",
            description: "Write down ideas with notes and categories like Living Room, Kitchen, or Bedroom. Mark your favorites so the best solutions are always easy to find."
        ),
        OnboardingPage(
            icon: "magnifyingglass",
            title: "Search & Filter",
            subtitle: "Find Inspiration Fast",
            description: "Use filters to quickly browse your catalog by category or keyword. View simple statistics that show how your design vision is shaping up over time."
        ),
        OnboardingPage(
            icon: "heart.fill",
            title: "Your Style Awaits",
            subtitle: "Start Creating",
            description: "Your apartment deserves a style that reflects you — and now you have the tool to organize and remember every inspiration."
        )
    ]
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? AppColors.primaryOrange : AppColors.primaryWhite.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .scaleEffect(index == currentPage ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.top, 60)
                .padding(.bottom, 40)
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index], isAnimating: $isAnimating)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 20) {
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
                                .font(AppFonts.buttonLarge())
                                .foregroundColor(AppColors.primaryWhite)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(AppColors.primaryWhite)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(AppGradients.buttonGradient)
                        .cornerRadius(28)
                        .shadow(color: AppColors.primaryOrange.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 40)
                    
                    if currentPage > 0 {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentPage -= 1
                            }
                        }) {
                            Text("Back")
                                .font(AppFonts.button())
                                .foregroundColor(AppColors.secondaryText)
                        }
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            isAnimating = true
        }
        .onChange(of: currentPage) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                isAnimating = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isAnimating = true
                }
            }
        }
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let subtitle: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @Binding var isAnimating: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardBackground)
                    .frame(width: 120, height: 120)
                    .overlay(
                        Circle()
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
                
                Image(systemName: page.icon)
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(AppColors.primaryOrange)
            }
            .scaleEffect(isAnimating ? 1.0 : 0.8)
            .opacity(isAnimating ? 1.0 : 0.7)
            .animation(.easeInOut(duration: 0.6).delay(0.1), value: isAnimating)
            
            VStack(spacing: 10) {
                Text(page.title)
                    .font(AppFonts.title1())
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.easeInOut(duration: 0.6).delay(0.2), value: isAnimating)
                
                Text(page.subtitle)
                    .font(AppFonts.headline())
                    .foregroundColor(AppColors.primaryOrange)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.easeInOut(duration: 0.6).delay(0.3), value: isAnimating)
                
                    Text(page.description)
                        .font(AppFonts.body())
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 20)
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .offset(y: isAnimating ? 0 : 20)
                        .animation(.easeInOut(duration: 0.6).delay(0.4), value: isAnimating)
            }
            
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    OnboardingView(viewModel: InteriorIdeasViewModel())
}
