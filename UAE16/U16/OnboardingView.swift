import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            title: "Track your gym visits with precision.",
            description: "This app helps you log your gym sessions by noting which muscle groups you trained and when your last visit was.",
            imageName: "figure.strengthtraining.traditional"
        ),
        OnboardingPage(
            title: "Keep a structured record",
            description: "View your progress over time, and stay consistent with clear tracking tools designed for disciplined training routines.",
            imageName: "chart.line.uptrend.xyaxis"
        ),
        OnboardingPage(
            title: "Monitor your muscle groups",
            description: "Easily track which muscle groups you've trained, ensuring balanced workouts and preventing overtraining specific areas.",
            imageName: "list.bullet.rectangle"
        ),
        OnboardingPage(
            title: "Stay motivated and consistent",
            description: "Set goals, track your consistency, and build a habit of regular gym visits with our intuitive progress tracking system.",
            imageName: "flame.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                VStack(spacing: 30) {
                    Image(systemName: pages[currentPage].imageName)
                        .font(.system(size: 80, weight: .light))
                        .foregroundColor(AppColors.lightBlue)
                        .padding(.bottom, 20)
                    
                    Text(pages[currentPage].title)
                        .font(.ubuntu(size: 28, weight: .bold))
                        .foregroundColor(AppColors.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                    
                    Text(pages[currentPage].description)
                        .font(.ubuntu(size: 16, weight: .regular))
                        .foregroundColor(AppColors.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .lineSpacing(4)
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? AppColors.lightBlue : AppColors.gray.opacity(0.5))
                            .frame(width: 8, height: 8)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 30)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage += 1
                        }
                    } else {
                        viewModel.completeOnboarding()
                    }
                }) {
                    Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                        .font(.ubuntu(size: 18, weight: .medium))
                        .foregroundColor(AppColors.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(AppColors.lightBlue)
                        )
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 20)
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -50 && currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage += 1
                        }
                    } else if value.translation.width > 50 && currentPage > 0 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage -= 1
                        }
                    }
                }
        )
    }
}

#Preview {
    OnboardingView(viewModel: WorkoutViewModel())
}
