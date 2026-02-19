import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appState: AppStateManager
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPage(
                        imageName: "wrench.and.screwdriver",
                        title: "Keep your garage organized.",
                        description: "This app helps you keep track of everything stored in your garage. Add tools, car care products and spare parts, note where each item is placed and keep your space organized. A simple way to know exactly what you have and where it is located."
                    )
                    .tag(0)
                    
                    OnboardingPage(
                        imageName: "location",
                        title: "Track locations easily",
                        description: "Organize your items by specific locations in your garage. From shelves to toolboxes, never lose track of where you put something."
                    )
                    .tag(1)
                    
                    OnboardingPage(
                        imageName: "magnifyingglass",
                        title: "Find items quickly",
                        description: "Use filters and search to instantly locate any tool, spare part, or car care product in your garage inventory."
                    )
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(currentPage == index ? AppColors.lightBlue : AppColors.white.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                .padding(.vertical, 20)
                
                Button(action: {
                    if currentPage < 2 {
                        withAnimation(.easeInOut) {
                            currentPage += 1
                        }
                    } else {
                        appState.completeOnboarding()
                    }
                }) {
                    Text(currentPage < 2 ? "Continue" : "Get Started")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(AppColors.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [AppColors.lightBlue, AppColors.orange]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage: View {
    let imageName: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: imageName)
                .font(.system(size: 70, weight: .light))
                .foregroundColor(AppColors.lightBlue)
                .padding(.top, 60)
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.white)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}
