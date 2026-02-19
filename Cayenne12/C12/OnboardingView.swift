import SwiftUI

struct OnboardingView: View {
    let onComplete: () -> Void
    
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPage1()
                        .tag(0)
                    
                    OnboardingPage2()
                        .tag(1)
                    
                    OnboardingPage3()
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? AppColors.orange : AppColors.white.opacity(0.3))
                            .frame(width: 10, height: 10)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                .padding(.bottom, 30)
                
                HStack(spacing: 20) {
                    if currentPage > 0 {
                        Button(action: {
                            withAnimation {
                                currentPage -= 1
                            }
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Previous")
                                    .font(.ubuntu(16, weight: .medium))
                            }
                            .foregroundColor(AppColors.white)
                            .frame(height: 44)
                            .padding(.horizontal, 20)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(AppColors.cardGradient)
                            )
                        }
                        
                        Spacer()
                    }
                                        
                    if currentPage < 2 {
                        Button(action: {
                            withAnimation {
                                currentPage += 1
                            }
                        }) {
                            HStack {
                                Text("Next")
                                    .font(.ubuntu(16, weight: .medium))
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(AppColors.white)
                            .frame(height: 44)
                            .padding(.horizontal, 20)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        LinearGradient(
                                            colors: [AppColors.orange, AppColors.orange.opacity(0.8)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                        }
                    } else {
                        Button(action: onComplete) {
                            HStack {
                                Text("Get Started")
                                    .font(.ubuntu(16, weight: .medium))
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(AppColors.white)
                            .frame(height: 44)
                            .padding(.horizontal, 20)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        LinearGradient(
                                            colors: [AppColors.orange, AppColors.orange.opacity(0.8)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage1: View {
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 120, height: 120)
                
                Image(systemName: "scissors")
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(AppColors.orange)
            }
            
            VStack(spacing: 20) {
                Text("Track your shaving and grooming routine.")
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Text("Log every shave, beard trim and grooming product you use. Build a clear routine history, review past sessions and understand how often you care for your beard. Keep all grooming notes in one simple place and stay consistent day by day.")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .lineSpacing(4)
            }
            
            Spacer()
        }
    }
}

struct OnboardingPage2: View {
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 120, height: 120)
                
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(AppColors.lightBlue)
            }
            
            VStack(spacing: 20) {
                Text("Keep a detailed history of your grooming sessions.")
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Text("Record each procedure with date, type, and products used. Review your grooming history to track patterns and maintain consistency. See when you last trimmed, shaved, or styled your beard.")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .lineSpacing(4)
            }
            
            Spacer()
        }
    }
}

struct OnboardingPage3: View {
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 120, height: 120)
                
                Image(systemName: "chart.bar")
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(AppColors.green)
            }
            
            VStack(spacing: 20) {
                Text("Analyze your product usage and preferences.")
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Text("Discover which grooming products you use most frequently. Track your favorite brands and find patterns in your routine. Make informed decisions about your beard care products.")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .lineSpacing(4)
            }
            
            Spacer()
        }
    }
}
