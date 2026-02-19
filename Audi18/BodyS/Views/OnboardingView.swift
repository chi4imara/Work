import SwiftUI

struct OnboardingView: View {
    @Binding var isShowingOnboarding: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPageView(
                        icon: "list.clipboard",
                        title: "Keep your care routine organized.",
                        description: "Create a clear list of your care procedures, organize them by days of the week, and follow simple checklists for each routine. The app helps you keep everything structured, remember what needs to be done today, and maintain a tidy system without unnecessary complexity.",
                        tag: 0
                    )
                    
                    OnboardingPageView(
                        icon: "calendar",
                        title: "Plan your weekly schedule.",
                        description: "Easily assign your care procedures to specific days of the week. Build a personalized routine that fits your lifestyle and helps you maintain consistency in your self-care journey.",
                        tag: 1
                    )
                    
                    OnboardingPageView(
                        icon: "checkmark.circle.fill",
                        title: "Track your daily progress.",
                        description: "Mark completed steps in your daily checklists and see your progress at a glance. Stay motivated and never miss an important step in your care routine.",
                        tag: 2
                    )
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                VStack(spacing: 20) {
                    Button(action: {
                        if currentPage < 2 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            withAnimation(.easeOut(duration: 0.5)) {
                                isShowingOnboarding = true
                                UserDefaults.standard.set(true, forKey: "Onboarding")
                            }
                        }
                    }) {
                        HStack {
                            Text(currentPage < 2 ? "Next" : "Get Started")
                                .font(.bellGothic(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            
                            Image(systemName: currentPage < 2 ? "arrow.right" : "checkmark")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppColors.primaryYellow)
                        .cornerRadius(12)
                        .shadow(color: AppColors.primaryYellow.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 50)
                }
            }
        }
    }
}

struct OnboardingPageView: View {
    let icon: String
    let title: String
    let description: String
    let tag: Int
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 150, height: 150)
                    .shadow(color: AppColors.primaryBlue.opacity(0.2), radius: 10, x: 0, y: 5)
                
                Image(systemName: icon)
                    .font(.system(size: 60))
                    .foregroundColor(AppColors.primaryBlue)
            }
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.bellGothic(size: 28, weight: .bold))
                    .foregroundColor(AppColors.primaryBlue)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.bellGothic(size: 16))
                    .foregroundColor(AppColors.darkGray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .tag(tag)
    }
}

#Preview {
    OnboardingView(isShowingOnboarding: .constant(true))
}
