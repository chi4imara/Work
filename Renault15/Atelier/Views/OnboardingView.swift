import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var isOnboardingCompleted: Bool
    
    private let onboardingData = [
        OnboardingPage(
            title: "Create Your Hair Style",
            description: "Try on hairstyles, plan looks and take care of your hair"
        ),
        OnboardingPage(
            title: "Daily Inspiration",
            description: "Save favorite hairstyles, plan new cuts and color experiments"
        ),
        OnboardingPage(
            title: "Personal Look Diary",
            description: "Keep track of hairstyles, save favorite options and rate changes"
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingData.count, id: \.self) { index in
                        OnboardingPageView(page: onboardingData[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack(spacing: 8) {
                    ForEach(0..<onboardingData.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? AppColors.primaryYellow : AppColors.primaryWhite.opacity(0.5))
                            .frame(width: 10, height: 10)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 40)
                
                Button(action: {
                    if currentPage < onboardingData.count - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    } else {
                        isOnboardingCompleted = true
                        UserDefaults.standard.set(true, forKey: "OnboardingCompleted")
                    }
                }) {
                    Text("Continue")
                        .font(AppFonts.button)
                        .foregroundColor(AppColors.darkBlue)
                        .frame(maxWidth: .infinity)
                        .frame(height: AppDimensions.buttonHeight)
                        .background(AppColors.primaryYellow)
                        .cornerRadius(AppDimensions.cornerRadius)
                }
                .padding(.horizontal, AppDimensions.screenPadding)
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.primaryWhite.opacity(0.2))
                    .frame(width: 200, height: 200)
                
                Circle()
                    .fill(AppColors.accentPink.opacity(0.3))
                    .frame(width: 150, height: 150)
                
                Circle()
                    .fill(AppColors.primaryYellow.opacity(0.6))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "scissors")
                    .font(.system(size: 40))
                    .foregroundColor(AppColors.darkBlue)
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(AppFonts.title)
                    .foregroundColor(AppColors.primaryWhite)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryWhite.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
            }
            
            Spacer()
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
}

#Preview {
    OnboardingView(isOnboardingCompleted: .constant(false))
}
