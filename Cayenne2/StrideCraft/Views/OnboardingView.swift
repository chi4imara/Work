import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var showOnboarding: Bool
    
    let pages = [
        OnboardingPage(
            title: "Keep your shoe collection organized.",
            description: "This app helps you track every pair you own. Add your models, note their condition, season and purchase date, and keep all your footwear organized in one clean catalog. Easily sort through categories and keep quick notes to manage your collection.",
            imageName: "shoe.2.fill"
        ),
        OnboardingPage(
            title: "Track every detail.",
            description: "Record the condition of each pair, categorize by type and season, and never forget when you purchased your favorite shoes. Keep detailed notes about each pair in your collection.",
            imageName: "list.bullet.clipboard.fill"
        ),
        OnboardingPage(
            title: "Organize by categories.",
            description: "Quickly find what you need by filtering your collection. Browse by shoe type, condition, or season. View statistics and insights about your entire collection at a glance.",
            imageName: "square.grid.2x2.fill"
        ),
        OnboardingPage(
            title: "Take notes and plan.",
            description: "Create notes for shoe care tips, shopping lists, or reminders. Keep everything related to your footwear collection in one convenient place.",
            imageName: "note.text"
        )
    ]
    
    var body: some View {
        ZStack {
            ColorTheme.primaryBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: {
                        closeOnboarding()
                    }) {
                        Text("Skip")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(ColorTheme.secondaryText)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                    }
                }
                .padding(.top, 10)
                .padding(.trailing, 20)
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 20) {
                    PageIndicator(currentPage: currentPage, totalPages: pages.count)
                    
                    HStack(spacing: 16) {
                        if currentPage > 0 {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentPage -= 1
                                }
                            }) {
                                Text("Previous")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(ColorTheme.primaryText)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(ColorTheme.cardBackground)
                                    .cornerRadius(25)
                            }
                        }
                        
                        Button(action: {
                            if currentPage < pages.count - 1 {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentPage += 1
                                }
                            } else {
                                closeOnboarding()
                            }
                        }) {
                            Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(ColorTheme.primaryText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(ColorTheme.primaryButton)
                                .cornerRadius(25)
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                }
            }
        }
    }
    
    private func closeOnboarding() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showOnboarding = false
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorTheme.lightBlue)
                .padding(.bottom, 20)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Text(page.description)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

struct PageIndicator: View {
    let currentPage: Int
    let totalPages: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? ColorTheme.primaryButton : ColorTheme.secondaryText.opacity(0.3))
                    .frame(width: index == currentPage ? 12 : 8, height: index == currentPage ? 12 : 8)
                    .animation(.easeInOut(duration: 0.3), value: currentPage)
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
