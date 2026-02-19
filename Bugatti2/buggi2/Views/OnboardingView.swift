import SwiftUI

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @EnvironmentObject var inventoryViewModel: InventoryViewModel
    @State private var currentPage = 0
    
    let pages = [
        OnboardingPage(
            title: "Keep track of what you own.",
            description: "This app helps you create a clear personal inventory of your belongings. Add items you own, note where they are stored, and record ownership details.",
            imageName: "house.fill"
        ),
        OnboardingPage(
            title: "Organize Everything",
            description: "It's a simple way to keep an organized overview of what you have at home, in the garage, or elsewhere, all in one clear list.",
            imageName: "archivebox.fill"
        ),
        OnboardingPage(
            title: "Find Anything Quickly",
            description: "Search through your inventory by name, location, or owner. Never lose track of your belongings again.",
            imageName: "magnifyingglass"
        )
    ]
    
    var body: some View {
        ZStack {
            GridBackgroundView()
            
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? AppColors.primaryYellow : AppColors.primaryTextWhite.opacity(0.5))
                            .frame(width: 10, height: 10)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.top, 60)
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 20) {
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage += 1
                            }
                        } else {
                            hasSeenOnboarding = true
                        }
                    }) {
                        HStack {
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                                .font(.playfairDisplay(18, weight: .semibold))
                                .foregroundColor(AppColors.backgroundWhite)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .foregroundColor(AppColors.backgroundWhite)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [AppColors.primaryBlue, AppColors.accentGreen],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 32)
                    
                    if currentPage > 0 {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage -= 1
                            }
                        }) {
                            Text("Back")
                                .font(.playfairDisplay(16, weight: .medium))
                                .foregroundColor(AppColors.primaryTextWhite)
                        }
                    }
                }
                .padding(.bottom, 50)
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
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppColors.primaryYellow.opacity(0.2), AppColors.primaryBlue.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: page.imageName)
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(AppColors.primaryTextWhite)
            }
            
            VStack(spacing: 24) {
                Text(page.title)
                    .font(.playfairDisplay(32, weight: .bold))
                    .foregroundColor(AppColors.primaryTextWhite)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(.playfairDisplay(18, weight: .medium))
                    .foregroundColor(AppColors.secondaryTextWhite)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(hasSeenOnboarding: .constant(false))
        .environmentObject(InventoryViewModel())
}
