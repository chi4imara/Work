import SwiftUI

struct OnboardingView: View {
    @Binding var isPresented: Bool
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            icon: "car.fill",
            title: "Plan every upgrade your car deserves.",
            description: "Create a clear and structured list of all your car upgrades. Track tuning ideas, technical improvements, expected budgets, and progress status.",
            color: AppColors.accentGreen
        ),
        OnboardingPage(
            icon: "folder.fill",
            title: "Organize by Categories",
            description: "Sort your modifications into categories like Exterior, Technical, Interior, Electrical, and more for better organization.",
            color: AppColors.accentPurple
        ),
        OnboardingPage(
            icon: "dollarsign.circle.fill",
            title: "Track Your Budget",
            description: "Monitor your spending with detailed budget breakdowns by category and individual modifications.",
            color: AppColors.accentYellow
        )
    ]
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    Button("Skip") {
                        completeOnboarding()
                    }
                    .font(FontManager.subheadline)
                    .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                VStack(spacing: 30) {
                    HStack(spacing: 12) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.primaryWhite : AppColors.primaryWhite.opacity(0.4))
                                .frame(width: 10, height: 10)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage += 1
                            }
                        } else {
                            completeOnboarding()
                        }
                    }) {
                        HStack(spacing: 12) {
                            Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                                .font(FontManager.headline)
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(AppColors.primaryWhite)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(AppColors.primaryDarkBlue)
                        )
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
        }
    }
    
    private func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "HasSeenOnboarding")
        isPresented = true
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var animateIcon = false
    @State private var animateText = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.2))
                    .frame(width: 160, height: 160)
                    .scaleEffect(animateIcon ? 1.1 : 1.0)
                
                Image(systemName: page.icon)
                    .font(.system(size: 60, weight: .medium))
                    .foregroundColor(page.color)
                    .scaleEffect(animateIcon ? 1.0 : 0.8)
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                    animateIcon = true
                }
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(FontManager.title1)
                    .foregroundColor(AppColors.primaryWhite)
                    .multilineTextAlignment(.center)
                    .opacity(animateText ? 1.0 : 0.0)
                    .offset(y: animateText ? 0 : 20)
                
                Text(page.description)
                    .font(FontManager.body)
                    .foregroundColor(AppColors.primaryWhite.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .opacity(animateText ? 1.0 : 0.0)
                    .offset(y: animateText ? 0 : 20)
            }
            .padding(.horizontal, 40)
            .onAppear {
                withAnimation(.easeOut(duration: 0.8).delay(0.5)) {
                    animateText = true
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(isPresented: .constant(true))
}
