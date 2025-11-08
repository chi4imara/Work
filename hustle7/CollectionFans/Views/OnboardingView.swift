import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appState: AppState
    @State private var currentPage = 0
    @State private var animateContent = false
    
    let pages = [
        OnboardingPage(
            icon: "square.grid.2x2.fill",
            title: "Organize your collections",
            description: "This app helps you keep track of your favorite collections — books, comics, figures, stamps, or anything you collect."
        ),
        OnboardingPage(
            icon: "plus.circle.fill",
            title: "Add and manage items",
            description: "Add items with details like title, category, and status. Mark what you already own, what you are looking for, and what you could trade."
        ),
        OnboardingPage(
            icon: "star.fill",
            title: "Stay organized",
            description: "Over time, your collections become structured and easy to browse. Search and filters make it simple to find exactly what you want, while favorites let you highlight your most valuable pieces."
        ),
        OnboardingPage(
            icon: "lock.fill",
            title: "Private and simple",
            description: "Everything is private and simple — your collections, always at your fingertips."
        )
    ]
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index], isActive: currentPage == index)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 24) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.primaryBlue : Color.lightBlue)
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
                            appState.completeOnboarding()
                        }
                    }) {
                        HStack {
                            Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                                .font(.buttonLarge)
                                .foregroundColor(.white)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.primaryBlue, Color.darkBlue]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                    }
                    .padding(.horizontal, 32)
                    
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            appState.completeOnboarding()
                        }
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                animateContent = true
            }
        }
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let isActive: Bool
    @State private var animateIcon = false
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.lightBlue.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .scaleEffect(animateIcon ? 1.1 : 1.0)
                
                Image(systemName: page.icon)
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(.primaryBlue)
                    .scaleEffect(animateIcon ? 1.0 : 0.8)
            }
            .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: animateIcon)
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.titleLarge)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.bodyLarge)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        }
        .onAppear {
            if isActive {
                animateIcon = true
            }
        }
        .onChange(of: isActive) { newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 0.5)) {
                    animateIcon = true
                }
            }
        }
    }
}

#Preview {
    OnboardingView(appState: AppState())
}
