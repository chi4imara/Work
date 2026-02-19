import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var currentPage = 0
    
    private let onboardingData = [
        OnboardingPage(
            title: "Listen to Your Body",
            description: "Track your well-being and perform simple care practices every day."
        ),
        OnboardingPage(
            title: "Without Rush or Demands",
            description: "Short exercises and habits that easily fit into your day."
        ),
        OnboardingPage(
            title: "Here You Can Be Gentle",
            description: "This space is created for your comfort and recovery."
        )
    ]
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    ForEach(0..<onboardingData.count, id: \.self) { index in
                        Capsule()
                            .fill(index <= currentPage ? ColorTheme.accentColor : ColorTheme.secondaryColor)
                            .frame(width: index == currentPage ? 24 : 8, height: 8)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.top, 60)
                .padding(.horizontal)
                
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingData.count, id: \.self) { index in
                        OnboardingPageView(page: onboardingData[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 20) {
                    Button(action: {
                        if currentPage == onboardingData.count - 1 {
                            dataManager.completeOnboarding()
                        } else {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage += 1
                            }
                        }
                    }) {
                        HStack {
                            Text("Continue")
                                .font(.playfair(18, weight: .medium))
                                .foregroundColor(.white)
                            
                            Image(systemName: "arrow.right")
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(ColorTheme.accentColor)
                        .cornerRadius(16)
                    }
                    .padding(.horizontal, 32)
                }
                .frame(height: 100)
                .animation(.easeInOut(duration: 0.3), value: currentPage)
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(ColorTheme.cardGradient)
                    .frame(width: 120, height: 120)
                    .shadow(color: ColorTheme.shadowColor, radius: 10, x: 0, y: 5)
                
                Image(systemName: getIconForPage())
                    .font(.system(size: 40))
                    .foregroundColor(ColorTheme.accentColor)
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.playfair(28, weight: .bold))
                    .foregroundColor(ColorTheme.textColor)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.playfair(16))
                    .foregroundColor(ColorTheme.secondaryColor)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
    }
    
    private func getIconForPage() -> String {
        switch page.title {
        case "Listen to Your Body":
            return "heart.circle"
        case "Without Rush or Demands":
            return "leaf.circle"
        case "Here You Can Be Gentle":
            return "hands.sparkles"
        default:
            return "heart.circle"
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(DataManager.shared)
}
