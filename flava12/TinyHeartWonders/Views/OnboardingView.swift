import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var isOnboardingComplete: Bool
    @ObservedObject var dataManager: DataManager
    
    let action: () -> Void
    
    private let pages = [
        OnboardingPage(
            title: "Capture the Unexpected",
            subtitle: "Remember Every Surprise",
            description: "This app is your personal journal for moments of wonder. Every day brings unexpected things — a fact, a discovery, a small event that made you pause.",
            systemImage: "lightbulb.fill"
        ),
        OnboardingPage(
            title: "Write Down Your Discoveries",
            subtitle: "Keep Your Daily Surprises",
            description: "Write them down with a title and short note, and keep your daily surprises in one place. Your Home view shows today's entries and makes it easy to add new ones.",
            systemImage: "pencil.and.outline"
        ),
        OnboardingPage(
            title: "Track Your Wonder Journey",
            subtitle: "See Your Progress",
            description: "History organizes everything you've logged, so you can revisit past days and see what amazed you. Statistics highlight your most active periods and give you a sense of how often life surprises you.",
            systemImage: "chart.bar.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            LinearGradient.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                VStack(spacing: 20) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.primaryBlue : AppColors.lightBlue)
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        print("Button tapped, currentPage: \(currentPage), totalPages: \(pages.count)")
                        if currentPage < pages.count - 1 {
                            print("Moving to next page")
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage += 1
                            }
                        } else {
                            print("Onboarding completed, setting isOnboardingComplete = true")
                            withAnimation(.easeInOut(duration: 0.3)) {
                                action()
                            }
                        }
                    }) {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(.appSubheadline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppColors.primaryBlue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 32)
                }
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let description: String
    let systemImage: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: page.systemImage)
                .font(.system(size: 80))
                .foregroundColor(AppColors.primaryBlue)
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.appTitle)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(page.subtitle)
                    .font(.appHeadline)
                    .foregroundColor(AppColors.blueText)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.appBody)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        }
    }
}
