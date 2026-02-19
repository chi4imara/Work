import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appViewModel: AppViewModel
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    let pages = [
        OnboardingPage(
            title: "Organize your tools by type",
            description: "Create a clear catalog of your tools with types, conditions and notes. Sort items into mechanical, woodworking or electrical groups and keep everything structured.",
            systemImage: "folder.badge.gearshape"
        ),
        OnboardingPage(
            title: "Track tool conditions",
            description: "Monitor the state of each tool - whether it's new, working properly, or needs repair. Add detailed comments to remember important maintenance notes.",
            systemImage: "checkmark.shield"
        ),
        OnboardingPage(
            title: "Quick access to everything",
            description: "Quickly access the tool you need and maintain an organized workshop. Find tools by category or search through your entire collection instantly.",
            systemImage: "magnifyingglass.circle"
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index], isAnimating: $isAnimating)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                VStack(spacing: 30) {
                    HStack(spacing: 12) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.lightBlue : AppColors.mediumGray)
                                .frame(width: 10, height: 10)
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
                            appViewModel.completeOnboarding()
                        }
                    }) {
                        HStack {
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                                .font(.playfairDisplay(size: 18, weight: .semibold))
                                .foregroundColor(.appWhite)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.appWhite)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(AppColors.buttonGradient)
                        .cornerRadius(16)
                        .shadow(color: AppColors.lightBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 32)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                isAnimating = true
            }
        }
        .onChange(of: currentPage) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                isAnimating = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    isAnimating = true
                }
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @Binding var isAnimating: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 120, height: 120)
                    .scaleEffect(isAnimating ? 1.0 : 0.8)
                    .opacity(isAnimating ? 1.0 : 0.6)
                
                Image(systemName: page.systemImage)
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(.appLightBlue)
                    .scaleEffect(isAnimating ? 1.0 : 0.8)
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(.appWhite)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 20)
                
                Text(page.description)
                    .font(.playfairDisplay(size: 16, weight: .regular))
                    .foregroundColor(.appSoftGray)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 30)
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let systemImage: String
}

#Preview {
    OnboardingView(appViewModel: AppViewModel())
}
