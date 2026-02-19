import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: ProcedureViewModel
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    let pages = [
        OnboardingPage(
            title: "Master Your Beard Routine",
            description: "Keep every part of your beard care in one organized place. Track trims, corrections, oils, balms, and styling steps.",
            imageName: "scissors"
        ),
        OnboardingPage(
            title: "Track Your Products",
            description: "Log each session with the products you used, review your monthly routine, and easily return to the details of any procedure whenever you need.",
            imageName: "drop"
        ),
        OnboardingPage(
            title: "Stay Organized",
            description: "View your complete beard care history, set reminders, and maintain the perfect grooming schedule.",
            imageName: "calendar"
        )
    ]
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index], isAnimating: isAnimating)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 30) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? ColorManager.accent : ColorManager.tertiaryText)
                                .frame(width: 8, height: 8)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
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
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                                .font(FontManager.ubuntu(18, weight: .medium))
                                .foregroundColor(ColorManager.primaryText)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .foregroundColor(ColorManager.primaryText)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(ColorManager.accentGradient)
                        .cornerRadius(25)
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                isAnimating = true
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let isAnimating: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(ColorManager.cardGradient)
                    .frame(width: 120, height: 120)
                    .scaleEffect(isAnimating ? 1.0 : 0.8)
                    .opacity(isAnimating ? 1.0 : 0.5)
                
                Image(systemName: page.imageName)
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(ColorManager.accent)
                    .scaleEffect(isAnimating ? 1.0 : 0.8)
            }
            .animation(.easeOut(duration: 0.8).delay(0.2), value: isAnimating)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(FontManager.ubuntu(28, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: isAnimating)
                
                Text(page.description)
                    .font(FontManager.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: isAnimating)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(viewModel: ProcedureViewModel())
}
