import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var isOnboardingCompleted: Bool
    
    private let pages = [
        OnboardingPage(
            title: "Grow your passions every day",
            description: "This app helps you turn hobbies into habits. Whether it's painting, learning music, or practicing a new language — you can track your progress, record sessions, and see how small steps add up over time.",
            imageName: "star.fill"
        ),
        OnboardingPage(
            title: "Track Your Progress",
            description: "On the main screen you'll find a calendar to mark your activities day by day. Each hobby gets its own detail page with progress indicators and a history of your sessions.",
            imageName: "chart.line.uptrend.xyaxis"
        ),
        OnboardingPage(
            title: "Analyze Your Growth",
            description: "Analytics helps you see which hobbies you focus on most, how your time is distributed, and when you're most consistent. With a clear interface and motivating tools, this organizer makes it easy to stay on track and celebrate achievements.",
            imageName: "chart.pie.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            WebPatternBackground()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 24) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? ColorTheme.primaryBlue : ColorTheme.lightBlue)
                                .frame(width: 10, height: 10)
                                .scaleEffect(index == currentPage ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage += 1
                            }
                        } else {
                            print("Get Started button pressed")
                            withAnimation(.easeInOut(duration: 0.5)) {
                                isOnboardingCompleted = true
                            }
                        }
                    }) {
                        HStack {
                            Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                                .font(FontManager.subheadline)
                                .foregroundColor(.white)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [ColorTheme.primaryBlue, ColorTheme.darkBlue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(25)
                        .shadow(color: ColorTheme.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 32)
                    
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            print("Skip button pressed")
                            withAnimation(.easeInOut(duration: 0.5)) {
                                isOnboardingCompleted = true
                            }
                        }
                        .font(FontManager.body)
                        .foregroundColor(ColorTheme.secondaryText)
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -50 && currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    } else if value.translation.width > 50 && currentPage > 0 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage -= 1
                        }
                    }
                }
        )
    }
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
                    .shadow(color: ColorTheme.lightBlue.opacity(0.3), radius: 20, x: 0, y: 10)
                
                Image(systemName: page.imageName)
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(ColorTheme.primaryBlue)
            }
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(FontManager.title)
                    .foregroundColor(ColorTheme.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                Text(page.description)
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}
