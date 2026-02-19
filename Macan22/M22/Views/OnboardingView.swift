import SwiftUI

struct OnboardingView: View {
    @Binding var isCompleted: Bool
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            title: "Your personal candle scent archive.",
            description: "Scent can transport you to another season, another memory, another mood. This app helps you capture those moments by building your personal archive of candle fragrances.",
            imageName: "flame.fill"
        ),
        OnboardingPage(
            title: "Organize your favorite scents",
            description: "Record every aroma you love — from cozy vanilla for winter nights to crisp citrus for summer mornings. Add details like brand, description, and season to remember exactly what made each scent special.",
            imageName: "heart.fill"
        ),
        OnboardingPage(
            title: "Find the perfect mood",
            description: "Filter your list by season or brand to rediscover what fits the moment. Maybe today calls for something warm and sweet, or maybe light and fresh. Whatever you choose, it's all organized in one calm, elegant space made just for you.",
            imageName: "magnifyingglass"
        )
    ]
    
    var body: some View {
        ZStack {
            AppBackground()
            
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
                                .fill(currentPage == index ? AppColors.yellow : AppColors.white.opacity(0.3))
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
                            withAnimation(.easeInOut(duration: 0.5)) {
                                UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                                isCompleted = true
                            }
                        }
                    }) {
                        HStack {
                            Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                                .font(.playfairDisplay(.semiBold, size: 18))
                                .foregroundColor(AppColors.white)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(AppColors.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(AppColors.buttonGradient)
                        .cornerRadius(28)
                        .shadow(color: AppColors.yellow.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -50 && currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage += 1
                        }
                    } else if value.translation.width > 50 && currentPage > 0 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage -= 1
                        }
                    }
                }
        )
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 110, height: 110)
                    .shadow(color: AppColors.deepBlue.opacity(0.3), radius: 20, x: 0, y: 10)
                
                Image(systemName: page.imageName)
                    .font(.system(size: 35, weight: .medium))
                    .foregroundColor(AppColors.yellow)
            }
            
            VStack(spacing: 24) {
                Text(page.title)
                    .font(.playfairDisplay(.bold, size: 28))
                    .foregroundColor(AppColors.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(.playfairDisplay(.regular, size: 15))
                    .foregroundColor(AppColors.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    OnboardingView(isCompleted: .constant(false))
}
