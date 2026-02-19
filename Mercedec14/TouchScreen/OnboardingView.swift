import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppStateManager
    @State private var currentPage = 0
    @State private var showingMainApp = false
    
    let pages = [
        OnboardingPage(
            title: "Relax and recharge anytime",
            description: "Discover personalized massage and SPA sessions, book trusted specialists, track your relaxation progress, and manage your wellness routine effortlessly.",
            imageName: "figure.mind.and.body",
            color: ColorTheme.primaryBlue
        ),
        OnboardingPage(
            title: "Find Perfect Masters",
            description: "Browse through verified massage therapists with ratings, reviews, and specializations to find the perfect match for your needs.",
            imageName: "person.2.fill",
            color: ColorTheme.primaryYellow
        ),
        OnboardingPage(
            title: "Track Your Progress",
            description: "Monitor your stress levels, view session history, and celebrate achievements on your wellness journey.",
            imageName: "chart.line.uptrend.xyaxis",
            color: ColorTheme.successGreen
        )
    ]
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 30) {
                    HStack(spacing: 12) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? ColorTheme.primaryBlue : ColorTheme.primaryBlue.opacity(0.3))
                                .frame(width: 12, height: 12)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.spring(response: 0.3), value: currentPage)
                        }
                    }
                    
                    HStack(spacing: 20) {
                        if currentPage > 0 {
                            Button("Back") {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentPage -= 1
                                }
                            }
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(ColorTheme.textSecondary)
                            .frame(maxWidth: .infinity)
                            
                            Spacer()
                        }
                        
                        Button {
                            if currentPage == pages.count - 1 {
                                completeOnboarding()
                            } else {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentPage += 1
                                }
                            }
                        } label: {
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Next")
                                .font(.ubuntu(16, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(ColorTheme.buttonGradient)
                                )
                                .shadow(color: ColorTheme.shadowColor, radius: 10, x: 0, y: 5)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            completeOnboarding()
                        }
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary)
                    }
                }
                .padding(.bottom, 50)
                .padding(.horizontal, 20)
            }
        }
    }
    
    private func completeOnboarding() {
        withAnimation(.easeOut(duration: 0.5)) {
            appState.completeOnboarding()
            showingMainApp = true
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var imageScale: CGFloat = 0.8
    @State private var textOpacity: Double = 0.0
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                page.color.opacity(0.2),
                                page.color.opacity(0.05)
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
                    .frame(width: 180, height: 180)
                
                Image(systemName: page.imageName)
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(page.color)
                    .scaleEffect(imageScale)
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.ubuntu(26, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                    .multilineTextAlignment(.center)
                    .opacity(textOpacity)
                
                Text(page.description)
                    .font(.ubuntu(15, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .opacity(textOpacity)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                imageScale = 1.0
            }
            
            withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
                textOpacity = 1.0
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
    let color: Color
}

#Preview {
    OnboardingView()
        .environmentObject(AppStateManager())
}
