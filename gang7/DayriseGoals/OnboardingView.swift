import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appViewModel: AppViewModel
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            TabView(selection: $currentPage) {
                OnboardingPage1()
                    .tag(0)
                
                OnboardingPage2()
                    .tag(1)
                
                OnboardingPage3(appViewModel: appViewModel)
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
    }
}

struct OnboardingPage1: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardBackground)
                    .frame(width: 200, height: 200)
                
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 80))
                    .foregroundColor(AppColors.textYellow)
            }
            
            VStack(spacing: 20) {
                Text("Start your day with intention.")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("This app gently welcomes you into each new morning.")
                    .font(.ubuntu(18, weight: .light))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct OnboardingPage2: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.cardBackground)
                    .frame(maxWidth: .infinity)
                    .frame(height: 150)
                
                VStack(spacing: 10) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 60))
                        .foregroundColor(AppColors.elementPurple)
                    
                    Text("What do I want from this day?")
                        .font(.ubuntu(20, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                }
            }
            
            VStack(spacing: 20) {
                Text("A simple question waits")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("There are no timers, goals, or pressure. Just space — for your words, for your attention, for your calm.")
                    .font(.ubuntu(18, weight: .light))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct OnboardingPage3: View {
    @ObservedObject var appViewModel: AppViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.cardBackground)
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                
                VStack(spacing: 8) {
                    HStack(spacing: 4) {
                        ForEach(0..<3) { _ in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(AppColors.textYellow)
                                .frame(width: 50, height: 5)
                        }
                    }
                    
                    Text("Your journal of intentions")
                        .font(.ubuntu(20, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                }
            }
            
            VStack(spacing: 20) {
                Text("A map of what matters")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("When you look back, you'll see quiet evidence of presence. A record of mornings lived consciously, one breath at a time.")
                    .font(.ubuntu(18, weight: .light))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            Button(action: {
                appViewModel.completeOnboarding()
            }) {
                Text("Continue")
                    .font(.ubuntu(20, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(AppColors.buttonBackground)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    OnboardingView(appViewModel: AppViewModel())
}
