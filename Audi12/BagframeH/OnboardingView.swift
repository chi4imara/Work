import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showMainApp = false
    @Binding var showOnboarding: Bool
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPage(
                        icon: "bag.fill",
                        title: "Organize your work bags with clarity.",
                        description: "Keep track of all your work bags and backpacks in one place. Save what items are inside each bag and note which days or situations they fit best.",
                        pageIndex: 0
                    )
                    .tag(0)
                    
                    OnboardingPage(
                        icon: "list.bullet.rectangle",
                        title: "Track items in each bag.",
                        description: "Never forget what's inside your bags. Add items to each bag and keep an organized inventory of everything you carry.",
                        pageIndex: 1
                    )
                    .tag(1)
                    
                    OnboardingPage(
                        icon: "calendar.badge.clock",
                        title: "Choose the right bag for any day.",
                        description: "Match your bags to specific days and scenarios. Quickly find the perfect bag for work, meetings, travel, or any occasion.",
                        pageIndex: 2
                    )
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(index == currentPage ? AppColors.yellow : AppColors.yellow.opacity(0.3))
                            .frame(width: 10, height: 10)
                    }
                }
                .padding(.bottom, 30)
                
                Button(action: {
                    if currentPage < 2 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showOnboarding = true
                            UserDefaults.standard.set(true, forKey: "isOnboardingCompleted")
                        }
                    }
                }) {
                    Text(currentPage < 2 ? "Continue" : "Get Started")
                        .font(.bellGothic(size: 18, weight: .bold))
                        .foregroundColor(AppColors.buttonText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppColors.buttonPrimary)
                        .cornerRadius(12)
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage: View {
    let icon: String
    let title: String
    let description: String
    let pageIndex: Int
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 80))
                .foregroundColor(AppColors.yellow)
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.bellGothic(size: 28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text(description)
                    .font(.bellGothic(size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .lineSpacing(4)
            }
            
            Spacer()
        }
    }
}
