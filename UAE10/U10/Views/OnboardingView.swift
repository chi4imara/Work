import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var measurementStore: MeasurementStore
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPageView(
                        imageName: "figure.walk",
                        title: "Track Your Body Progress",
                        description: "Build a clear view of your physical measurements over time. Add each entry manually, choose the areas you track, and see how your numbers change with simple visual charts.",
                        isLastPage: false,
                        currentPage: $currentPage
                    )
                    .tag(0)
                    
                    OnboardingPageView(
                        imageName: "figure.arms.open",
                        title: "Monitor Body Zones",
                        description: "Track different body zones separately - weight, chest, arms, and shoulders. Each zone has its own history and progress tracking to help you focus on specific areas.",
                        isLastPage: false,
                        currentPage: $currentPage
                    )
                    .tag(1)
                    
                    OnboardingPageView(
                        imageName: "chart.line.uptrend.xyaxis",
                        title: "Visual Progress Tracking",
                        description: "From weight to chest and arm size, keep all progress organized and easy to review whenever you need it. Watch your transformation unfold with detailed charts and statistics.",
                        isLastPage: false,
                        currentPage: $currentPage
                    )
                    .tag(2)
                    
                    OnboardingPageView(
                        imageName: "list.clipboard",
                        title: "Stay Organized",
                        description: "Keep all your measurements in one place. Add notes to each entry, edit or delete records anytime. Your data is stored securely on your device.",
                        isLastPage: true,
                        currentPage: $currentPage
                    )
                    .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("CompleteOnboarding"))) { _ in
            measurementStore.completeOnboarding()
        }
    }
}

struct OnboardingPageView: View {
    let imageName: String
    let title: String
    let description: String
    let isLastPage: Bool
    @Binding var currentPage: Int
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.lightBlue)
                .padding(.bottom, 20)
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.ubuntu(32, weight: .bold))
                    .foregroundColor(AppColors.white)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .lineSpacing(4)
            }
            
            Spacer()
            
            VStack(spacing: 20) {
                if isLastPage {
                    Button(action: {
                        NotificationCenter.default.post(name: Notification.Name("CompleteOnboarding"), object: nil)
                    }) {
                        HStack {
                            Text("Get Started")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(AppColors.white)
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppColors.white)
                        }
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(AppColors.buttonGradient)
                        .cornerRadius(25)
                    }
                } else {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    }) {
                        HStack {
                            Text("Continue")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(AppColors.white)
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppColors.white)
                        }
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(AppColors.buttonGradient)
                        .cornerRadius(25)
                    }
                }
                
                if !isLastPage {
                    Button(action: {
                        NotificationCenter.default.post(name: Notification.Name("CompleteOnboarding"), object: nil)
                    }) {
                        Text("Skip")
                            .font(.ubuntu(16))
                            .foregroundColor(AppColors.white.opacity(0.6))
                    }
                }
            }
            .padding(.bottom, 50)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    OnboardingView()
        .environmentObject(MeasurementStore())
}
