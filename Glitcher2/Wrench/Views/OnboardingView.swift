import SwiftUI

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
}

struct OnboardingView: View {
    @Binding var isOnboardingCompleted: Bool
    @State private var currentPage = 0
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "wrench.and.screwdriver.fill",
            title: "Organize your garage projects.",
            description: "Create and track your garage tasks with clear structure. Add projects to repair, paint or upgrade, update their progress and record completed results. Keep your workshop workflow organized and always know what has been done and what still needs attention."
        ),
        OnboardingPage(
            icon: "list.bullet.clipboard",
            title: "Track your progress.",
            description: "Monitor all your projects in one place. View them by category, check completion status, and see detailed statistics. Never lose track of what needs to be done in your garage."
        ),
        OnboardingPage(
            icon: "chart.bar.fill",
            title: "Stay organized and efficient.",
            description: "Group projects by categories, add detailed comments and results. Keep your workshop organized with an intuitive interface designed for garage enthusiasts."
        )
    ]
    
    var body: some View {
        ZStack {
            ColorManager.primaryBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 20) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? ColorManager.lightBlue : ColorManager.primaryText.opacity(0.3))
                                .frame(width: index == currentPage ? 12 : 8, height: index == currentPage ? 12 : 8)
                                .animation(.spring(response: 0.3), value: currentPage)
                        }
                    }
                    .padding(.top, 20)
                    
                    HStack(spacing: 16) {
                        if currentPage > 0 {
                            Button(action: {
                                withAnimation {
                                    currentPage -= 1
                                }
                            }) {
                                HStack {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 16, weight: .medium))
                                    Text("Previous")
                                        .font(.ubuntu(16, weight: .medium))
                                }
                                .foregroundColor(ColorManager.primaryText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(ColorManager.cardBackground)
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
                                )
                            }
                        }
                        
                        Button(action: {
                            if currentPage < pages.count - 1 {
                                withAnimation {
                                    currentPage += 1
                                }
                            } else {
                                isOnboardingCompleted = true
                                UserDefaults.standard.set(true, forKey: "OnboardingCompleted")
                            }
                        }) {
                            HStack {
                                Text(currentPage < pages.count - 1 ? "Next" : "Continue")
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(.white)
                                
                                Image(systemName: currentPage < pages.count - 1 ? "arrow.right" : "checkmark")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [ColorManager.lightBlue, ColorManager.orange]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: ColorManager.lightBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 50)
                }
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.icon)
                .font(.system(size: 80))
                .foregroundColor(ColorManager.lightBlue)
                .padding(.bottom, 20)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.ubuntu(32, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Text(page.description)
                    .font(.ubuntu(16))
                    .foregroundColor(ColorManager.primaryText.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(isOnboardingCompleted: .constant(false))
}
