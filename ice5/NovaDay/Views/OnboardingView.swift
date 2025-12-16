import SwiftUI

struct OnboardingView: View {
    @ObservedObject var memoryStore: MemoryStore
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                OnboardingPageView(
                    imageName: "book.fill",
                    title: "Save Your Days",
                    subtitle: "Build Your Story",
                    description: "This app is your memory journal — every day, you can save one special event."
                )
                .tag(0)
                
                OnboardingPageView(
                    imageName: "calendar",
                    title: "Track Your Journey",
                    subtitle: "Month by Month",
                    description: "Step by step, your month and year fill with moments, moods, and emotions."
                )
                .tag(1)
                
                OnboardingPageView(
                    imageName: "heart.fill",
                    title: "Cherish Memories",
                    subtitle: "Personal & Simple",
                    description: "Look back at your calendar, highlight your favorite days, and see summaries of your journey. Simple, reflective, and personal — your story, one day at a time.",
                    showButton: true,
                    buttonAction: {
                        memoryStore.completeOnboarding()
                    }
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
    let subtitle: String
    let description: String
    var showButton: Bool = false
    var buttonAction: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryBlue)
            
            VStack(spacing: 16) {
                Text(title)
                    .font(.ubuntu(32, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(.ubuntu(24, weight: .medium))
                    .foregroundColor(AppColors.primaryYellow)
                    .multilineTextAlignment(.center)
            }
            
            Text(description)
                .font(.ubuntu(18, weight: .regular))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .lineSpacing(4)
            
            Spacer()
            
            if showButton {
                Button(action: {
                    buttonAction?()
                }) {
                    HStack {
                        Text("Continue")
                            .font(.ubuntu(18, weight: .medium))
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(AppColors.primaryBlue)
                    .cornerRadius(25)
                }
                .padding(.bottom, 50)
            } else {
                Spacer()
                    .frame(height: 100)
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    OnboardingView(memoryStore: MemoryStore())
}
