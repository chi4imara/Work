import SwiftUI

struct OnboardingView: View {
    @ObservedObject var productViewModel: ProductViewModel
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    private let pages = [
        OnboardingPage(
            title: "Organize Your Grooming Essentials",
            description: "Keep all your grooming products in one simple, structured place. Add items you use every day, update their status, mark last use, and track what's running low.",
            imageName: "drop.circle.fill",
            color: ColorTheme.lightBlue
        ),
        OnboardingPage(
            title: "Track Usage & Stock Levels",
            description: "From oils and creams to shampoos and balms, build a clear system that helps you stay organized and never lose track of your essentials.",
            imageName: "chart.bar.fill",
            color: ColorTheme.orange
        ),
        OnboardingPage(
            title: "Never Run Out Again",
            description: "Get organized with categories, monitor stock levels, and keep notes about your favorite products. Your grooming routine, simplified.",
            imageName: "checkmark.circle.fill",
            color: ColorTheme.green
        )
    ]
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index], isAnimating: $isAnimating)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                VStack(spacing: 30) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? ColorTheme.lightBlue : ColorTheme.secondaryText)
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
                            productViewModel.completeOnboarding()
                        }
                    }) {
                        HStack {
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                                .font(.playfairDisplay(18, weight: .semibold))
                                .foregroundColor(ColorTheme.primaryText)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(ColorTheme.primaryText)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(ColorTheme.buttonGradient)
                        .cornerRadius(12)
                        .shadow(color: ColorTheme.lightBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 40)
                    
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            productViewModel.completeOnboarding()
                        }
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(ColorTheme.secondaryText)
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            isAnimating = true
        }
        .onChange(of: currentPage) { _ in
            isAnimating = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isAnimating = true
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @Binding var isAnimating: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.2))
                    .frame(width: 140, height: 140)
                    .scaleEffect(isAnimating ? 1.0 : 0.8)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: isAnimating)
                
                Image(systemName: page.imageName)
                    .font(.system(size: 60, weight: .medium))
                    .foregroundColor(page.color)
                    .scaleEffect(isAnimating ? 1.0 : 0.5)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: isAnimating)
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.playfairDisplay(28, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: isAnimating)
                
                Text(page.description)
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 30)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.easeOut(duration: 0.8).delay(0.8), value: isAnimating)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    OnboardingView(productViewModel: ProductViewModel())
}
