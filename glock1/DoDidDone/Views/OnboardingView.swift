import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var animateElements = false
    let onComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            icon: "house.fill",
            title: "Home Organizer",
            subtitle: "Small tasks, big order",
            description: "This app helps you stay on top of everyday little things at home. Make checklists, add tasks like changing a bulb or buying batteries, and mark them done when finished.",
            color: AppColors.accentYellow
        ),
        OnboardingPage(
            icon: "list.bullet.circle.fill",
            title: "Smart Checklists",
            subtitle: "Organize by categories",
            description: "Create tasks and organize them by categories like Electrical, Plumbing, Shopping, and more. Keep track of what needs to be done around your home.",
            color: AppColors.successGreen
        ),
        OnboardingPage(
            icon: "chart.pie.fill",
            title: "Track Progress",
            subtitle: "See your achievements",
            description: "Monitor your progress with beautiful charts and statistics. See how many tasks you've completed and stay motivated to keep your home organized.",
            color: AppColors.primaryBlue
        ),
        OnboardingPage(
            icon: "checkmark.circle.fill",
            title: "Get Started",
            subtitle: "Ready to organize?",
            description: "Clear, simple, and practical — because even small tasks matter. Start organizing your home today and experience the difference!",
            color: AppColors.warningOrange
        )
    ]
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(
                            page: pages[index],
                            animateElements: animateElements
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                bottomControls
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.3)) {
                animateElements = true
            }
        }
    }
    
    private var bottomControls: some View {
        VStack(spacing: 30) {
            HStack(spacing: 8) {
                ForEach(0..<pages.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? AppColors.accentYellow : AppColors.tertiaryText)
                        .frame(width: 8, height: 8)
                        .scaleEffect(index == currentPage ? 1.2 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: currentPage)
                }
            }
            
            Button(action: {
                if currentPage < pages.count - 1 {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        currentPage += 1
                    }
                } else {
                    onComplete()
                }
            }) {
                HStack {
                    Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                        .font(AppFonts.callout())
                        .fontWeight(.semibold)
                    
                    if currentPage < pages.count - 1 {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                    } else {
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(AppColors.accentYellow)
                        .shadow(color: AppColors.accentYellow.opacity(0.3), radius: 10, x: 0, y: 5)
                )
            }
            .padding(.horizontal, 40)
            
            if currentPage < pages.count - 1 {
                Button("Skip") {
                    onComplete()
                }
                .font(AppFonts.callout())
                .foregroundColor(AppColors.secondaryText)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 50)
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let subtitle: String
    let description: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let animateElements: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.2))
                    .frame(width: 90, height: 90)
                    .scaleEffect(animateElements ? 1.0 : 0.8)
                    .opacity(animateElements ? 1.0 : 0.0)
                
                Image(systemName: page.icon)
                    .font(.system(size: 35, weight: .medium))
                    .foregroundColor(page.color)
                    .scaleEffect(animateElements ? 1.0 : 0.5)
                    .opacity(animateElements ? 1.0 : 0.0)
            }
            .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2), value: animateElements)
            
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text(page.title)
                        .font(AppFonts.title2())
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.center)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : 20)
                    
                    Text(page.subtitle)
                        .font(AppFonts.title3())
                        .foregroundColor(page.color)
                        .multilineTextAlignment(.center)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : 20)
                }
                .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.4), value: animateElements)
                
                Text(page.description)
                    .font(AppFonts.subheadline())
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 20)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : 30)
                    .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.6), value: animateElements)
            }
            
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
