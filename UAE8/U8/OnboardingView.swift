import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @State private var currentPage = 0
    private let totalPages = 4
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                pageContent
                
                Spacer()
                
                pageIndicators
                
                HStack {
                    if currentPage > 0 {
                        Button("Back") {
                            withAnimation(.easeInOut) {
                                currentPage -= 1
                            }
                        }
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(ColorManager.secondaryText)
                    }
                    
                    Spacer()
                    
                    Button {
                        if currentPage < totalPages - 1 {
                            withAnimation(.easeInOut) {
                                currentPage += 1
                            }
                        } else {
                            viewModel.completeOnboarding()
                        }
                    } label: {
                        Text(currentPage == totalPages - 1 ? "Get Started" : "Continue")
                            .font(.ubuntu(18, weight: .bold))
                            .foregroundColor(ColorManager.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 15)
                            .background(
                                LinearGradient(
                                    colors: [ColorManager.lightBlue, ColorManager.orange],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(25)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
    }
    
    private var pageContent: some View {
        Group {
            switch currentPage {
            case 0:
                onboardingContent
            case 1:
                secondPageContent
            case 2:
                thirdPageContent
            case 3:
                fourthPageContent
            default:
                onboardingContent
            }
        }
    }
    
    private var pageIndicators: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                Circle()
                    .fill(currentPage == index ? ColorManager.lightBlue : ColorManager.secondaryText.opacity(0.3))
                    .frame(width: currentPage == index ? 10 : 8, height: currentPage == index ? 10 : 8)
                    .animation(.easeInOut, value: currentPage)
            }
        }
    }
    
    private var onboardingContent: some View {
        VStack(spacing: 30) {
            ZStack {
                Circle()
                    .fill(ColorManager.cardGradient)
                    .frame(width: 120, height: 120)
                
                Image(systemName: "calendar.badge.plus")
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(ColorManager.lightBlue)
            }
            
            VStack(spacing: 20) {
                Text("Build Your Weekly Training Plan")
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Create a clear weekly workout structure that fits your routine. Choose a training type for each day, add notes, and keep your plan organized in one place.")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 30)
        }
    }
    
    private var secondPageContent: some View {
        VStack(spacing: 30) {
            ZStack {
                Circle()
                    .fill(ColorManager.cardGradient)
                    .frame(width: 120, height: 120)
                
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(ColorManager.orange)
            }
            
            VStack(spacing: 20) {
                Text("Track Your Progress")
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("From strength sessions to technique days, shape your own schedule and quickly access what you planned for the entire week. Mark completed workouts and track your fitness journey.")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 30)
        }
    }
    
    private var thirdPageContent: some View {
        VStack(spacing: 30) {
            ZStack {
                Circle()
                    .fill(ColorManager.cardGradient)
                    .frame(width: 120, height: 120)
                
                Image(systemName: "list.bullet.rectangle")
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(ColorManager.purple)
            }
            
            VStack(spacing: 20) {
                Text("Organize by Categories")
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("View your workouts organized by training types. Easily see how many days you've dedicated to strength, cardio, technique, and other training categories. Stay balanced and focused on your goals.")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 30)
        }
    }
    
    private var fourthPageContent: some View {
        VStack(spacing: 30) {
            ZStack {
                Circle()
                    .fill(ColorManager.cardGradient)
                    .frame(width: 120, height: 120)
                
                Image(systemName: "chart.bar")
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(ColorManager.green)
            }
            
            VStack(spacing: 20) {
                Text("Monitor Your Statistics")
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Track your training statistics and completion rates. See your progress at a glance with visual charts and insights. Stay motivated by watching your consistency grow week after week.")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 30)
        }
    }
}

#Preview {
    OnboardingView(viewModel: WorkoutViewModel())
}
