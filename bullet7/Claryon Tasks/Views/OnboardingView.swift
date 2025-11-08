import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: CleaningZoneViewModel
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                OnboardingPageView(
                    imageName: "house.fill",
                    title: "Keep your space clean, one zone at a time.",
                    description: "This app helps you stay organized in the simplest way possible — by dividing your home into zones and cleaning them one by one.",
                    isLastPage: false,
                    onContinue: { currentPage = 1 }
                )
                .tag(0)
                
                OnboardingPageView(
                    imageName: "checkmark.circle.fill",
                    title: "Track Your Progress",
                    description: "You can add areas like the kitchen, bathroom, or floors, and mark them when done. Each time you check off a task, you'll see your progress grow — room by room, step by step.",
                    isLastPage: false,
                    onContinue: { currentPage = 2 }
                )
                .tag(1)
                
                OnboardingPageView(
                    imageName: "heart.fill",
                    title: "Stay Calm and Organized",
                    description: "There's no pressure, no timers, and no reminders — just a calm way to keep your home comfortable and your mind clear. Cleaning becomes easier when it's visual and rewarding. Start small, stay consistent, and enjoy the feeling of order every day.",
                    isLastPage: true,
                    onContinue: { viewModel.completeOnboarding() }
                )
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
    }
}

struct OnboardingPageView: View {
    let imageName: String
    let title: String
    let description: String
    let isLastPage: Bool
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(.accentYellow)
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.titleLarge)
                    .foregroundColor(.primaryWhite)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Text(description)
                    .font(.bodyMedium)
                    .foregroundColor(.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 30)
            }
            
            Spacer()
            
            Button(action: onContinue) {
                Text(isLastPage ? "Get Started" : "Continue")
                    .font(.bodyLarge)
                    .foregroundColor(.primaryPurple)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.accentYellow)
                    .cornerRadius(25)
                    .padding(.horizontal, 40)
            }
            .padding(.bottom, 50)
        }
    }
}

#Preview {
    OnboardingView(viewModel: CleaningZoneViewModel())
}
