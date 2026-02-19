import SwiftUI

struct OnboardingView: View {
    @ObservedObject var bagStore: BagStore
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPageView(
                        imageName: "bag.fill",
                        title: "Choose the right bag every day",
                        description: "Organize your bags by size, style, and daily use scenarios. Keep photos, notes, and clear categories to quickly see what you own and select the perfect bag for your plans.",
                        pageIndex: 0
                    )
                    .tag(0)
                    
                    OnboardingPageView(
                        imageName: "square.grid.2x2",
                        title: "Organize by Categories",
                        description: "Sort your bags by size and style. Find exactly what you need for any occasion with smart filtering and search features.",
                        pageIndex: 1
                    )
                    .tag(1)
                    
                    OnboardingPageView(
                        imageName: "heart.fill",
                        title: "Mark Your Favorites",
                        description: "A simple and structured way to make confident choices without overthinking. Save your most-used bags for quick access.",
                        pageIndex: 2
                    )
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(index == currentPage ? Color.appPrimaryBlue : Color.appPrimaryBlue.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 30)
                
                Button(action: {
                    if currentPage < 2 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage += 1
                        }
                    } else {
                        bagStore.completeOnboarding()
                    }
                }) {
                    Text(currentPage < 2 ? "Continue" : "Get Started")
                        .font(.bellGothic(18, weight: .bold))
                        .foregroundColor(.appDarkBlue)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.appAccentYellow)
                        .cornerRadius(25)
                        .shadow(color: Color.appAccentYellow.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPageView: View {
    let imageName: String
    let title: String
    let description: String
    let pageIndex: Int
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: imageName)
                .font(.system(size: 80, weight: .bold))
                .foregroundColor(.appPrimaryBlue)
                .padding(.top, 60)
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.bellGothic(28, weight: .bold))
                    .foregroundColor(.appDarkBlue)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Text(description)
                    .font(.bellGothic(16))
                    .foregroundColor(.appTextDark)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}
