import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var animateContent = false
    
    let onComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            title: "Stay Organized. Stay Healthy.",
            description: "This app helps you build a clear, structured routine for taking your medicines — completely offline, with no accounts or reminders.",
            systemImage: "pills.fill",
            color: AppColors.successGreen
        ),
        OnboardingPage(
            title: "Track Your Progress",
            description: "Create your own list of medications, specify when and on which days you take them, and mark each dose as taken or missed.",
            systemImage: "calendar.badge.checkmark",
            color: AppColors.accentBlue
        ),
        OnboardingPage(
            title: "Visual Calendar",
            description: "The built-in calendar visualizes your progress: green days mean success, red days mark missed doses, and yellow days remind you that something's still unmarked.",
            systemImage: "calendar",
            color: AppColors.warningYellow
        ),
        OnboardingPage(
            title: "Private & Secure",
            description: "Your data stays on your device only — private and secure. You can review detailed histories for every medication, track your adherence over time, and keep personal notes in the built-in medicine reference.",
            systemImage: "lock.shield.fill",
            color: AppColors.primaryPurple
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index], isActive: currentPage == index)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                VStack(spacing: 30) {
                    HStack(spacing: 12) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.primaryText : AppColors.secondaryText)
                                .frame(width: currentPage == index ? 12 : 8, height: currentPage == index ? 12 : 8)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    HStack {
                        if currentPage > 0 {
                            Button(action: previousPage) {
                                HStack {
                                    Image(systemName: "chevron.left")
                                    Text("Back")
                                }
                                .font(AppFonts.callout())
                                .foregroundColor(AppColors.primaryText)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(AppColors.secondaryButton)
                                .clipShape(Capsule())
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: nextPage) {
                            HStack {
                                Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                                if currentPage < pages.count - 1 {
                                    Image(systemName: "chevron.right")
                                }
                            }
                            .font(AppFonts.callout())
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .background(AppColors.primaryButton)
                            .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: 0.8)) {
                animateContent = true
            }
        }
    }
    
    private func nextPage() {
        if currentPage < pages.count - 1 {
            withAnimation(.easeInOut(duration: 0.5)) {
                currentPage += 1
            }
        } else {
            onComplete()
        }
    }
    
    private func previousPage() {
        if currentPage > 0 {
            withAnimation(.easeInOut(duration: 0.5)) {
                currentPage -= 1
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let systemImage: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let isActive: Bool
    
    @State private var animateIcon = false
    @State private var animateText = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [page.color.opacity(0.3), page.color.opacity(0.1)],
                            center: .center,
                            startRadius: 50,
                            endRadius: 100
                        )
                    )
                    .frame(width: 100, height: 100)
                    .scaleEffect(animateIcon ? 1.0 : 0.8)
                    .opacity(animateIcon ? 1.0 : 0.0)
                
                Image(systemName: page.systemImage)
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(.white)
                    .scaleEffect(animateIcon ? 1.0 : 0.5)
                    .opacity(animateIcon ? 1.0 : 0.0)
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(AppFonts.title1())
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .opacity(animateText ? 1.0 : 0.0)
                    .offset(y: animateText ? 0 : 20)
                
                Text(page.description)
                    .font(AppFonts.body())
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .opacity(animateText ? 1.0 : 0.0)
                    .offset(y: animateText ? 0 : 30)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .onChange(of: isActive) { newValue in
            if newValue {
                withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                    animateIcon = true
                }
                withAnimation(.easeOut(duration: 0.8).delay(0.4)) {
                    animateText = true
                }
            } else {
                animateIcon = false
                animateText = false
            }
        }
        .onAppear {
            if isActive {
                withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                    animateIcon = true
                }
                withAnimation(.easeOut(duration: 0.8).delay(0.4)) {
                    animateText = true
                }
            }
        }
    }
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
