import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    let onComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            title: "Keep track of everything you own.",
            description: "This app helps you organize your home inventory. Add tools, gadgets, parts and accessories, assign storage places and track their condition.",
            imageName: "house.fill"
        ),
        OnboardingPage(
            title: "Organize by Categories",
            description: "Sort your items into categories like Tools, Gadgets, Parts, Equipment, and Accessories for easy management.",
            imageName: "folder.fill"
        ),
        OnboardingPage(
            title: "Track Condition & Location",
            description: "Build a clear overview of your belongings so you always know what you have and where it is.",
            imageName: "location.fill"
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
                
                HStack(spacing: 12) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? AppColors.orange : AppColors.primaryText.opacity(0.3))
                            .frame(width: 12, height: 12)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3), value: currentPage)
                    }
                }
                .padding(.vertical, 30)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    } else {
                        onComplete()
                    }
                }) {
                    HStack {
                        Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(AppColors.primaryText)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(AppColors.orangeGradient)
                    .cornerRadius(25)
                    .shadow(color: AppColors.shadowColor, radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 130, height: 130)
                    .shadow(color: AppColors.shadowColor, radius: 20, x: 0, y: 10)
                
                Image(systemName: page.imageName)
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(AppColors.lightBlue)
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.playfairDisplay(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(.playfairDisplay(17, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
