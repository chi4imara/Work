import SwiftUI

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @State private var currentPage = 0
    private let totalPages = 3
    
    var body: some View {
        ZStack {
                            AppColors.universalGradient
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? AppColors.primary : AppColors.lightGray)
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                .padding(.top, 60)
                .padding(.bottom, 40)
                
                TabView(selection: $currentPage) {
                    OnboardingPage(
                        imageName: "leaf.fill",
                        title: "Plan Your Garden",
                        subtitle: "Harvest With Ease",
                        description: "Taking care of a garden is easier when you have a clear plan. This app gives you a seasonal calendar of tasks: when to plant, when to water, and when to fertilize."
                    )
                    .tag(0)
                    
                    OnboardingPage(
                        imageName: "calendar",
                        title: "Track Your Tasks",
                        subtitle: "Stay Organized",
                        description: "Every crop has its cycle. Add the plants you grow, see their care schedule, and mark tasks as done. The main screen shows today's work, while the calendar keeps you prepared for the upcoming weeks."
                    )
                    .tag(1)
                    
                    OnboardingPage(
                        imageName: "checkmark.circle.fill",
                        title: "Simple Guidance",
                        subtitle: "No More Guessing",
                        description: "No more guessing — just simple, structured guidance for your garden. Get personalized recommendations and keep track of your gardening journey."
                    )
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                Button(action: {
                    if currentPage < totalPages - 1 {
                        withAnimation(.easeInOut) {
                            currentPage += 1
                        }
                    } else {
                        hasSeenOnboarding = true
                    }
                }) {
                    Text(currentPage == totalPages - 1 ? "Get Started" : "Continue")
                        .font(.appHeadline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(AppColors.primary)
                        .cornerRadius(25)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
                
                if currentPage < totalPages - 1 {
                    Button(action: {
                        hasSeenOnboarding = true
                    }) {
                        Text("Skip")
                            .font(.appCallout)
                            .foregroundColor(.appMediumGray)
                    }
                    .padding(.bottom, 30)
                }
            }
        }
    }
}

struct OnboardingPage: View {
    let imageName: String
    let title: String
    let subtitle: String
    let description: String
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.primary.opacity(0.1))
                    .frame(width: 98, height: 98)
                
                Image(systemName: imageName)
                    .font(.system(size: 45, weight: .medium))
                    .foregroundColor(.appPrimary)
            }
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.appTitle1)
                    .foregroundColor(.appPrimary)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(.appTitle3)
                    .foregroundColor(.appAccent)
                    .multilineTextAlignment(.center)
            }
            
            HStack {
                Spacer()
                
                Text(description)
                    .font(.appBody)
                    .foregroundColor(.appDarkGray)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Spacer()
            }
            
            Spacer()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(hasSeenOnboarding: .constant(false))
    }
}
