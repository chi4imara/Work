import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var opacity = 0.0
    var onComplete: () -> Void
    
    let pages = [
        OnboardingPage(
            title: "Stay Organized. Study Smarter.",
            description: "This app is your personal assistant for all things school. It helps you keep track of homework, exams, and schedules for every subject.",
            imageName: "book.circle"
        ),
        OnboardingPage(
            title: "Never Miss a Deadline",
            description: "Organize your study tasks, set deadlines, and monitor your progress. Never worry about forgetting something again.",
            imageName: "calendar.badge.clock"
        ),
        OnboardingPage(
            title: "Make School Simpler",
            description: "With this app, school becomes simpler and more effective. Start your organized learning journey today!",
            imageName: "graduationcap.fill"
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
                
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? AppColors.primaryBlue : AppColors.lightBlue)
                            .frame(width: 10, height: 10)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                .padding(.vertical, 20)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut) {
                            currentPage += 1
                        }
                    } else {
                        onComplete()
                    }
                }) {
                    Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                        .font(.appSubheadline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.primaryBlue)
                        )
                        .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeIn(duration: 0.5)) {
                opacity = 1.0
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var imageScale = 0.8
    @State private var textOpacity = 0.0
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.system(size: 80))
                .foregroundColor(AppColors.primaryBlue)
                .scaleEffect(imageScale)
                .animation(.spring(response: 0.8, dampingFraction: 0.6), value: imageScale)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.appTitle)
                    .foregroundColor(.appText)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.appBody)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
            .padding(.horizontal, 40)
            .opacity(textOpacity)
            .animation(.easeIn(duration: 0.8).delay(0.3), value: textOpacity)
            
            Spacer()
        }
        .onAppear {
            imageScale = 1.0
            textOpacity = 1.0
        }
    }
}
