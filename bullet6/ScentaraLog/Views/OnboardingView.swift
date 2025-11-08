import SwiftUI

struct OnboardingView: View {
    @Binding var isCompleted: Bool
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            title: "Remember your days by scents",
            description: "This app is your personal scent diary — a quiet place to capture the fragrances that color your everyday life.",
            systemImage: "leaf.fill"
        ),
        OnboardingPage(
            title: "Capture Every Moment",
            description: "Each day you can write down the smells that surrounded you — morning coffee, rain on the pavement, blooming flowers, or even the scent of a book.",
            systemImage: "pencil.and.outline"
        ),
        OnboardingPage(
            title: "Build Your Memory Collection",
            description: "Every note becomes a small memory tied to emotion and time. As your collection grows, you'll start to recognize how certain scents bring back moments, people, and feelings you thought were forgotten.",
            systemImage: "heart.fill"
        ),
        OnboardingPage(
            title: "Notice Your World",
            description: "Use this space to slow down, notice your world more deeply, and keep the invisible traces of your days. It's not about perfection — it's about remembering what made you feel alive.",
            systemImage: "sparkles"
        )
    ]
    
    var body: some View {
        ZStack {
            LinearGradient.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 30) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? AppColors.primaryPurple : AppColors.lightText)
                                .frame(width: 8, height: 8)
                                .scaleEffect(index == currentPage ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage += 1
                            }
                        } else {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                isCompleted = true
                            }
                        }
                    }) {
                        Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.buttonText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.buttonBackground)
                            )
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
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
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.systemImage)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryPurple)
                .padding(.bottom, 20)
            
            Text(page.title)
                .font(AppFonts.largeTitle)
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            Text(page.description)
                .font(AppFonts.body)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(isCompleted: .constant(false))
}
