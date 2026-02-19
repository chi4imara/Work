import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var onboardingDone: Bool
    
    private let pages = [
        OnboardingPage(
            title: "Create Your Style",
            description: "Add items to your wardrobe and create outfits every day",
            systemImage: "tshirt.fill"
        ),
        OnboardingPage(
            title: "Plan and Get Inspired",
            description: "Save favorite outfits, plan combinations and purchases",
            systemImage: "heart.fill"
        ),
        OnboardingPage(
            title: "Personal Fashion Journal",
            description: "Keep track of outfit history, monitor your combinations and find inspiration",
            systemImage: "book.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.gradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? AppColors.primary : AppColors.primary.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.top, 60)
                .padding(.bottom, 40)
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    } else {
                        onboardingDone = true
                        UserDefaults.standard.set(true, forKey: "OnDone")
                    }
                }) {
                    Text("Continue")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(AppColors.primary)
                        .cornerRadius(25)
                        .shadow(color: AppColors.shadow, radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 40)
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
                .font(.system(size: 80))
                .foregroundColor(AppColors.accent)
                .shadow(color: AppColors.shadow, radius: 10, x: 0, y: 5)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}
