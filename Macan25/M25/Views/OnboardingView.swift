import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var isCompleted: Bool
    
    private let pages = [
        OnboardingPage(
            image: "eyeglasses",
            title: "Keep your accessories in perfect order.",
            description: "From sunglasses to belts, gloves, and umbrellas — every accessory has its story. This app helps you keep them all organized in one elegant place."
        ),
        OnboardingPage(
            image: "plus.circle.fill",
            title: "Add and organize with ease",
            description: "Add your items manually, note their condition, and always know what you have, what's in repair, and which pieces you love most."
        ),
        OnboardingPage(
            image: "line.3.horizontal.decrease.circle",
            title: "Filter and find instantly",
            description: "You can filter items by category or status to quickly find what you're looking for — your favorite glasses, a missing umbrella, or that perfect belt for a trip."
        ),
        OnboardingPage(
            image: "heart.circle.fill",
            title: "Your personal style catalog",
            description: "Over time, your list becomes more than storage — it's a reflection of your style and your sense of order. Create your own accessory catalog — neat, detailed, and beautifully organized."
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
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
                
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? AppColors.primaryWhite : AppColors.primaryWhite.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .scaleEffect(index == currentPage ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 30)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage += 1
                        }
                    } else {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isCompleted = true
                        }
                    }
                }) {
                    Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(AppColors.primaryPurple)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(AppColors.primaryWhite)
                        .cornerRadius(25)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
                .padding(.horizontal, 40)
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
    let image: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.image)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryWhite)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.primaryWhite)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.primaryWhite.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(isCompleted: .constant(false))
}
