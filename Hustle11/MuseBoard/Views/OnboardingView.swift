import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showMainApp = false
    
    let onComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            icon: "lightbulb",
            title: "Capture Ideas",
            subtitle: "Build Your Creativity",
            description: "Never lose a spark of inspiration again. Write down your ideas instantly, whether it's a startup concept, design detail, story plot, or personal goal."
        ),
        OnboardingPage(
            icon: "folder",
            title: "Organize Everything",
            subtitle: "Categories & Tags",
            description: "Structure your thoughts with categories like Work, Hobby, Travel, Family and add custom tags for easy searching and grouping."
        ),
        OnboardingPage(
            icon: "star",
            title: "Build Your Library",
            subtitle: "Grow With Time",
            description: "Watch your notebook become a library of creativity. Quick notes turn into detailed projects, random sparks evolve into structured plans."
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
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.primaryText : AppColors.primaryText.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentPage += 1
                            }
                        } else {
                            onComplete()
                        }
                    }) {
                        HStack {
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                                .font(.nunito(.semiBold, size: 18))
                                .foregroundColor(AppColors.primaryBlue)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(AppColors.primaryBlue)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                        )
                    }
                    .padding(.horizontal, 40)
                    
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            onComplete()
                        }
                        .font(.nunito(.medium, size: 16))
                        .foregroundColor(AppColors.primaryText.opacity(0.7))
                    }
                }
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var animateIcon = false
    @State private var animateText = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .scaleEffect(animateIcon ? 1.1 : 1.0)
                
                Image(systemName: page.icon)
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(AppColors.primaryText)
                    .scaleEffect(animateIcon ? 1.0 : 0.8)
            }
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: true)
                ) {
                    animateIcon = true
                }
            }
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.nunito(.bold, size: 32))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(page.subtitle)
                    .font(.nunito(.semiBold, size: 20))
                    .foregroundColor(AppColors.primaryText.opacity(0.8))
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.nunito(.regular, size: 16))
                    .foregroundColor(AppColors.primaryText.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 20)
            }
            .opacity(animateText ? 1.0 : 0.0)
            .offset(y: animateText ? 0 : 20)
            .onAppear {
                withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
                    animateText = true
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let subtitle: String
    let description: String
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView {
            print("Onboarding completed")
        }
    }
}
