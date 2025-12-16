import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    @State private var animateContent = false
    
    private let pages = [
        OnboardingPage(
            title: "Track Your Mood",
            description: "Record your daily emotions with simple emoji selections",
            systemImage: "face.smiling",
            color: AppColors.happyMood
        ),
        OnboardingPage(
            title: "Understand Your Days",
            description: "Add notes to capture what made your day special or challenging",
            systemImage: "note.text",
            color: AppColors.primaryText
        ),
        OnboardingPage(
            title: "Build Awareness",
            description: "This app helps you record your daily mood in the simplest way. Pick an emoji that reflects your day, add a short note, and watch your emotions form a colorful calendar. Look back at your month, explore how your feelings change, and build awareness step by step.",
            systemImage: "calendar",
            color: AppColors.accent
        )
    ]
    
    var body: some View {
        ZStack {
            GradientBackground()
            
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
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.accent : AppColors.accent.opacity(0.3))
                                .frame(width: 10, height: 10)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentPage += 1
                            }
                        } else {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showOnboarding = false
                            }
                        }
                    }) {
                        HStack {
                            Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                                .font(FontManager.ubuntu(size: 18, weight: .medium))
                                .foregroundColor(.white)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [AppColors.accent, AppColors.accent.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(28)
                        .shadow(color: AppColors.shadowColor, radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 40)
                    .scaleEffect(animateContent ? 1.0 : 0.9)
                    .opacity(animateContent ? 1.0 : 0.0)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
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
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.1))
                    .frame(width: 140, height: 140)
                    .scaleEffect(animateIcon ? 1.0 : 0.8)
                
                Image(systemName: page.systemImage)
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(page.color)
                    .scaleEffect(animateIcon ? 1.0 : 0.7)
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(FontManager.ubuntu(size: 32, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .opacity(animateText ? 1.0 : 0.0)
                    .offset(y: animateText ? 0 : 20)
                
                Text(page.description)
                    .font(FontManager.ubuntu(size: 16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .opacity(animateText ? 1.0 : 0.0)
                    .offset(y: animateText ? 0 : 30)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .onChange(of: isActive) { active in
            if active {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.1)) {
                    animateIcon = true
                }
                withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
                    animateText = true
                }
            } else {
                animateIcon = false
                animateText = false
            }
        }
        .onAppear {
            if isActive {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.1)) {
                    animateIcon = true
                }
                withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
                    animateText = true
                }
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

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
