import SwiftUI

struct OnboardingView: View {
    let onComplete: () -> Void
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPage(
                        icon: "figure.strengthtraining.traditional",
                        title: "Structure your training cycles.",
                        description: "Create clear training phases such as mass, strength and endurance. Add results for every session, switch phases when needed and keep your training cycle organized. A simple way to plan your workouts and follow your progress across each stage.",
                        pageIndex: 0
                    )
                    .tag(0)
                    
                    OnboardingPage(
                        icon: "chart.line.uptrend.xyaxis",
                        title: "Track Your Progress",
                        description: "Monitor your performance over time with detailed analytics. See your workout frequency, phase distribution, and training statistics. Visualize your journey and identify areas for improvement.",
                        pageIndex: 1
                    )
                    .tag(1)
                    
                    OnboardingPage(
                        icon: "calendar.badge.plus",
                        title: "Plan Your Phases",
                        description: "Organize your training into distinct phases: mass building, strength development, and endurance training. Each phase can have multiple workouts with detailed results and comments.",
                        pageIndex: 2
                    )
                    .tag(2)
                    
                    OnboardingPage(
                        icon: "list.bullet.clipboard",
                        title: "Record Every Session",
                        description: "Log your workouts with dates, types, and results. Add comments to track how you felt, what worked well, and what needs adjustment. Keep a complete history of your training journey.",
                        pageIndex: 3
                    )
                    .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                HStack(spacing: 8) {
                    ForEach(0..<4) { index in
                        Circle()
                            .fill(index == currentPage ? AppColors.orange : AppColors.white.opacity(0.3))
                            .frame(width: index == currentPage ? 10 : 8, height: index == currentPage ? 10 : 8)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                .padding(.top, 20)
                
                HStack(spacing: 20) {
                    if currentPage > 0 {
                        Button(action: {
                            withAnimation {
                                currentPage -= 1
                            }
                        }) {
                            Text("Previous")
                                .font(.custom("PlayfairDisplay-SemiBold", size: 16))
                                .foregroundColor(AppColors.white)
                                .frame(height: 45)
                                .frame(maxWidth: .infinity)
                                .background(AppColors.lightBlue.opacity(0.5))
                                .cornerRadius(22)
                        }
                        
                        Spacer()
                    }
                    
                    
                    Button(action: {
                        if currentPage < 3 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            onComplete()
                        }
                    }) {
                        Text(currentPage < 3 ? "Next" : "Get Started")
                            .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                            .foregroundColor(AppColors.white)
                            .frame(height: 45)
                            .frame(maxWidth: .infinity)
                            .background(AppColors.orange)
                            .cornerRadius(25)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.top, 20)
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
            
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 120, height: 120)
                
                Image(systemName: icon)
                    .font(.system(size: 50))
                    .foregroundColor(AppColors.orange)
            }
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.custom("PlayfairDisplay-Bold", size: 28))
                    .foregroundColor(AppColors.white)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.custom("PlayfairDisplay-Regular", size: 16))
                    .foregroundColor(AppColors.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
