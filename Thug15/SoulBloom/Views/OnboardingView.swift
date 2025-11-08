import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboardingComplete: Bool
    @State private var currentPage = 0
    @State private var animateContent = false
    
    private let pages = [
        OnboardingPage(
            systemImage: "heart.fill",
            title: "Start Your Gratitude Journey",
            description: "This app helps you build a daily habit of gratitude. Every day, write down three things you are thankful for — big or small."
        ),
        OnboardingPage(
            systemImage: "calendar",
            title: "Track Your Progress",
            description: "Your notes are stored in a colorful calendar and list, making it easy to look back and reflect on your journey."
        ),
        OnboardingPage(
            systemImage: "chart.line.uptrend.xyaxis",
            title: "See Your Growth",
            description: "Statistics show your progress, streaks, and how consistent you are in practicing gratitude. Simple, mindful, and motivating — your personal diary of thankfulness, one day at a time."
        )
    ]
    
    var body: some View {
        ZStack {
            LinearGradient.appBackground
                .ignoresSafeArea()
            
            GridPatternView()
                .opacity(0.2)
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index], isActive: currentPage == index)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                VStack(spacing: 20) {
                    HStack(spacing: 12) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? ColorTheme.accentYellow : ColorTheme.primaryText.opacity(0.3))
                                .frame(width: 10, height: 10)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    HStack(spacing: 15) {
                        if currentPage > 0 {
                            Button {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentPage -= 1
                                }
                            } label: {
                                Text("Back")
                                    .font(FontManager.callout)
                                    .foregroundColor(ColorTheme.primaryText)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(ColorTheme.primaryText.opacity(0.2))
                                    )
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            if currentPage == pages.count - 1 {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    isOnboardingComplete = true
                                }
                            } else {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentPage += 1
                                }
                            }
                        } label: {
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                                .font(FontManager.body)
                                .foregroundColor(ColorTheme.buttonText)
                                .padding(.horizontal, 25)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(ColorTheme.buttonBackground)
                                )
                                .scaleEffect(animateContent ? 1.0 : 0.9)
                                .opacity(animateContent ? 1.0 : 0.7)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                animateContent = true
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let isActive: Bool
    @State private var animateIcon = false
    @State private var animateText = false
    
    var body: some View {
        VStack(spacing: 25) {
            Spacer()
            
            Image(systemName: page.systemImage)
                .font(.system(size: 60, weight: .light))
                .foregroundColor(ColorTheme.accentYellow)
                .scaleEffect(animateIcon ? 1.0 : 0.5)
                .opacity(animateIcon ? 1.0 : 0.3)
                .rotationEffect(.degrees(animateIcon ? 0 : -10))
            
            VStack(spacing: 15) {
                Text(page.title)
                    .font(FontManager.title)
                    .foregroundColor(ColorTheme.primaryText)
                    .multilineTextAlignment(.center)
                    .opacity(animateText ? 1.0 : 0.0)
                    .offset(y: animateText ? 0 : 20)
                
                Text(page.description)
                    .font(FontManager.callout)
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.horizontal, 20)
                    .opacity(animateText ? 1.0 : 0.0)
                    .offset(y: animateText ? 0 : 30)
            }
            
            Spacer()
        }
        .onChange(of: isActive) { newValue in
            if newValue {
                withAnimation(.easeOut(duration: 0.6)) {
                    animateIcon = true
                }
                withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
                    animateText = true
                }
            } else {
                animateIcon = false
                animateText = false
            }
        }
        .onAppear {
            if isActive {
                withAnimation(.easeOut(duration: 0.6)) {
                    animateIcon = true
                }
                withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
                    animateText = true
                }
            }
        }
    }
}

struct OnboardingPage {
    let systemImage: String
    let title: String
    let description: String
}

#Preview {
    OnboardingView(isOnboardingComplete: .constant(false))
}
