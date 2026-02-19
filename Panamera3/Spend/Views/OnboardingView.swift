import SwiftUI

struct OnboardingView: View {
    @ObservedObject var budgetViewModel: BudgetViewModel
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    let pages = [
        OnboardingPage(
            icon: "creditcard.fill",
            title: "Plan your fashion budget wisely.",
            description: "Set a clear spending limit for clothing, track every purchase, and see how your budget changes over time."
        ),
        OnboardingPage(
            icon: "chart.bar.fill",
            title: "Track Every Purchase",
            description: "Keep your wardrobe plans organized, record expenses instantly, and use simple charts to understand how close you are to your limit."
        ),
        OnboardingPage(
            icon: "checkmark.circle.fill",
            title: "Stay in Control",
            description: "Monitor your spending habits, set realistic budgets, and make informed decisions about your fashion purchases."
        )
    ]
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.theme.accentYellow : Color.theme.textWhite.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .scaleEffect(index == currentPage ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.top, 60)
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index], isAnimating: $isAnimating)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .onAppear {
                    isAnimating = true
                }
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage += 1
                        }
                    } else {
                        budgetViewModel.completeOnboarding()
                    }
                }) {
                    Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                        .font(.lumierepolis(18, weight: .bold))
                        .foregroundColor(Color.theme.textBlack)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.theme.buttonGradient)
                        .cornerRadius(28)
                        .shadow(color: Color.theme.accentYellow.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @Binding var isAnimating: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.icon)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(Color.theme.accentYellow)
                .scaleEffect(isAnimating ? 1.0 : 0.5)
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.8).delay(0.2), value: isAnimating)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.lumierepolis(28, weight: .bold))
                    .foregroundColor(Color.theme.textWhite)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: isAnimating)
                
                Text(page.description)
                    .font(.lumierepolis(16, weight: .light))
                    .foregroundColor(Color.theme.textWhite.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: isAnimating)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(budgetViewModel: BudgetViewModel())
}
