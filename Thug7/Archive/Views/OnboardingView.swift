import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    @State private var animateElements = false
    
    private let pages = [
        OnboardingPage(
            title: "Remember Where It All Began",
            description: "This app is your personal archive of childhood places — the schoolyard where you played, the street where you lived, the parks and trips that shaped your memories.",
            imageName: "location.circle.fill",
            color: AppTheme.primaryBlue
        ),
        OnboardingPage(
            title: "Capture Your Stories",
            description: "Every entry captures not just the name of a place but also the story behind it. You can add categories, write descriptions, and revisit them anytime.",
            imageName: "book.circle.fill",
            color: AppTheme.accentPurple
        ),
        OnboardingPage(
            title: "Organize & Reflect",
            description: "Over time, your archive becomes a map of the past — a timeline of meaningful locations that defined your childhood. Categories keep everything structured, while statistics give you a new perspective.",
            imageName: "chart.bar.fill",
            color: AppTheme.accentOrange
        )
    ]
    
    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                VStack(spacing: 20) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppTheme.primaryBlue : AppTheme.textSecondary.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    .padding(.top, 20)
                    
                    HStack(spacing: 20) {
                        if currentPage > 0 {
                            Button("Back") {
                                withAnimation {
                                    currentPage -= 1
                                }
                            }
                            .secondaryButtonStyle()
                        }
                        
                        Spacer()
                        
                        Button(currentPage == pages.count - 1 ? "Get Started" : "Next") {
                            if currentPage == pages.count - 1 {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    showOnboarding = true
                                }
                            } else {
                                withAnimation {
                                    currentPage += 1
                                }
                            }
                        }
                        .primaryButtonStyle()
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            animateElements = true
        }
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
    @State private var animateContent = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(page.color)
                .scaleEffect(animateContent ? 1.0 : 0.5)
                .opacity(animateContent ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(AppTheme.titleFont)
                    .foregroundColor(AppTheme.textPrimary)
                    .multilineTextAlignment(.center)
                    .offset(y: animateContent ? 0 : 30)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: animateContent)
                
                Text(page.description)
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 30)
                    .offset(y: animateContent ? 0 : 30)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.8).delay(0.6), value: animateContent)
            }
            
            Spacer()
        }
        .onAppear {
            animateContent = true
        }
        .onDisappear {
            animateContent = false
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(showOnboarding: .constant(true))
    }
}
