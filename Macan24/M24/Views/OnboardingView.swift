import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showingMainApp = false
    @Binding var isComplete: Bool
    
    private let pages = [
        OnboardingPage(
            title: "Create your personal breakfast journal",
            description: "Every breakfast can be a small celebration — a moment of calm, taste, and beauty before the day begins.",
            imageName: "cup.and.saucer.fill",
            color: AppColors.primaryBlue
        ),
        OnboardingPage(
            title: "Capture beautiful mornings",
            description: "This app helps you capture those details that make mornings special. Combine your favorite dishes, drinks, and table settings into elegant entries.",
            imageName: "sparkles",
            color: AppColors.primaryYellow
        ),
        OnboardingPage(
            title: "Your personal style",
            description: "Over time, your collection becomes a gallery of mornings that reflect your style, your rhythm, your version of comfort. No calories, no scores, no rules — just the art of documenting beautiful mornings, one breakfast at a time.",
            imageName: "heart.fill",
            color: AppColors.accentGreen
        )
    ]
    
    var body: some View {
        if showingMainApp {
            MainTabView()
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
        } else {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 0) {
                    pageIndicator
                        .padding(.top, 60)
                    
                    TabView(selection: $currentPage) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            OnboardingPageView(page: pages[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .animation(.easeInOut, value: currentPage)
                    
                    navigationButtons
                        .padding(.bottom, 50)
                }
            }
        }
    }
    
    private var pageIndicator: some View {
        HStack(spacing: 12) {
            ForEach(0..<pages.count, id: \.self) { index in
                Circle()
                    .fill(currentPage == index ? AppColors.primaryYellow : AppColors.primaryBlue.opacity(0.3))
                    .frame(width: currentPage == index ? 12 : 8, height: currentPage == index ? 12 : 8)
                    .scaleEffect(currentPage == index ? 1.2 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
            }
        }
    }
    
    private var navigationButtons: some View {
        HStack {
            if currentPage < pages.count - 1 {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                        isComplete = true                    }
                }) {
                    Text("Skip")
                        .font(.playfairDisplay(size: 16, weight: .medium))
                        .foregroundColor(AppColors.textGray)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(AppColors.backgroundWhite.opacity(0.7))
                        .cornerRadius(25)
                }
                
                Spacer()
            }
            
            Button(action: {
                if currentPage < pages.count - 1 {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentPage += 1
                    }
                } else {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                        isComplete = true
                    }
                }
            }) {
                HStack(spacing: 8) {
                    Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                        .font(.playfairDisplay(size: 18, weight: .semibold))
                        .foregroundColor(AppColors.backgroundWhite)
                    
                    if currentPage < pages.count - 1 {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppColors.backgroundWhite)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        colors: [AppColors.primaryYellow, AppColors.accentOrange],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(30)
                .shadow(color: AppColors.primaryYellow.opacity(0.4), radius: 12, x: 0, y: 6)
            }
        }
        .padding(.horizontal, 30)
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [page.color.opacity(0.3), page.color.opacity(0.1), Color.clear],
                            center: .center,
                            startRadius: 20,
                            endRadius: 80
                        )
                    )
                    .frame(width: 140, height: 140)
                
                Circle()
                    .fill(page.color.opacity(0.2))
                    .frame(width: 100, height: 100)
                
                Image(systemName: page.imageName)
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(page.color)
            }
            
            VStack(spacing: 24) {
                Text(page.title)
                    .font(.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(AppColors.primaryBlue)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(.playfairDisplay(size: 16, weight: .regular))
                    .foregroundColor(AppColors.textGray)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
    }
}
