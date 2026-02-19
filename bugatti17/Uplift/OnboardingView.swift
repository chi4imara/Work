import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var dragOffset: CGSize = .zero
    let onComplete: () -> Void
    
    private let screens = AppConstants.Onboarding.screens
    
    var body: some View {
        ZStack {
            AnimatedBackgroundView()
            
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    ForEach(0..<screens.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? DesignConstants.Colors.primaryYellow : DesignConstants.Colors.white.opacity(0.3))
                            .frame(width: 10, height: 10)
                            .scaleEffect(index == currentPage ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.top, 80)
                .padding(.bottom, 40)
                
                TabView(selection: $currentPage) {
                    ForEach(0..<screens.count, id: \.self) { index in
                        OnboardingPageView(
                            title: screens[index].title,
                            description: screens[index].description,
                            pageIndex: index
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                VStack(spacing: 20) {
                    Button(action: {
                        if currentPage < screens.count - 1 {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentPage += 1
                            }
                        } else {
                            onComplete()
                        }
                    }) {
                        HStack {
                            Text(currentPage == screens.count - 1 ? "Get Started" : "Continue")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(DesignConstants.Colors.primaryBlue)
                            
                            if currentPage < screens.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(DesignConstants.Colors.primaryBlue)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(DesignConstants.Colors.primaryYellow)
                        .cornerRadius(DesignConstants.CornerRadius.large)
                        .shadow(color: DesignConstants.Colors.primaryYellow.opacity(0.3), radius: 10, x: 0, y: 4)
                    }
                    .padding(.horizontal, DesignConstants.Spacing.lg)
                    
                    if currentPage < screens.count - 1 {
                        Button("Skip") {
                            onComplete()
                        }
                        .font(.ubuntu(16))
                        .foregroundColor(DesignConstants.Colors.white.opacity(0.7))
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .ignoresSafeArea()
    }
}

struct OnboardingPageView: View {
    let title: String
    let description: String
    let pageIndex: Int
    
    @State private var titleOpacity: Double = 0
    @State private var descriptionOpacity: Double = 0
    @State private var iconScale: CGFloat = 0.5
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                DesignConstants.Colors.primaryYellow.opacity(0.2),
                                DesignConstants.Colors.white.opacity(0.1)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .scaleEffect(iconScale)
                
                Image(systemName: getIconForPage(pageIndex))
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(DesignConstants.Colors.primaryYellow)
                    .scaleEffect(iconScale)
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                    iconScale = 1.0
                }
            }
            
            Spacer()
            
            VStack(spacing: DesignConstants.Spacing.lg) {
                Text(title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(DesignConstants.Colors.white)
                    .multilineTextAlignment(.center)
                    .opacity(titleOpacity)
                    .onAppear {
                        withAnimation(.easeOut(duration: 0.6).delay(0.4)) {
                            titleOpacity = 1.0
                        }
                    }
                
                Text(description)
                    .font(.ubuntu(18))
                    .foregroundColor(DesignConstants.Colors.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .opacity(descriptionOpacity)
                    .onAppear {
                        withAnimation(.easeOut(duration: 0.6).delay(0.6)) {
                            descriptionOpacity = 1.0
                        }
                    }
            }
            .padding(.horizontal, DesignConstants.Spacing.xl)
            
            Spacer()
        }
    }
    
    private func getIconForPage(_ index: Int) -> String {
        switch index {
        case 0:
            return "sun.max.fill"
        case 1:
            return "arrow.up.right.circle.fill"
        case 2:
            return "star.fill"
        default:
            return "heart.fill"
        }
    }
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
