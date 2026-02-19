import SwiftUI

struct OnboardingView: View {
    let onComplete: () -> Void
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            ColorManager.shared.primaryBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPage(
                        icon: "scissors",
                        title: "Keep every barber visit in order.",
                        description: "This app helps you track your haircuts, shaves, and grooming sessions. Log each visit with the date, selected services, and barber's name.",
                        iconColor: ColorManager.shared.accentBlue
                    )
                    .tag(0)
                    
                    OnboardingPage(
                        icon: "chart.bar.fill",
                        title: "Track your grooming history",
                        description: "Review your full history, check your stats, and analyze your grooming patterns with detailed statistics and visual charts.",
                        iconColor: ColorManager.shared.accentOrange
                    )
                    .tag(1)
                    
                    OnboardingPage(
                        icon: "calendar",
                        title: "Stay organized",
                        description: "Keep your grooming routine organized with a simple and structured tracking journal. Never forget when you last visited your barber.",
                        iconColor: ColorManager.shared.successColor
                    )
                    .tag(2)
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                VStack(spacing: 20) {
                    Button(action: {
                        if currentPage < 2 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            onComplete()
                        }
                    }) {
                        HStack {
                            Text(currentPage < 2 ? "Next" : "Continue")
                                .font(FontManager.playfairSemiBold(size: 18))
                                .foregroundColor(ColorManager.shared.primaryText)
                            
                            Image(systemName: currentPage < 2 ? "arrow.right" : "checkmark")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(ColorManager.shared.primaryText)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(ColorManager.shared.accentBlue)
                        )
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                }
            }
        }
    }
}

struct OnboardingPage: View {
    let icon: String
    let title: String
    let description: String
    let iconColor: Color
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(ColorManager.shared.cardBackground)
                    .frame(width: 120, height: 120)
                
                Image(systemName: icon)
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(iconColor)
            }
            
            VStack(spacing: 20) {
                Text(title)
                    .font(FontManager.playfairBold(size: 28))
                    .foregroundColor(ColorManager.shared.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(description)
                    .font(FontManager.playfairRegular(size: 16))
                    .foregroundColor(ColorManager.shared.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .padding(.vertical, 40)
    }
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
