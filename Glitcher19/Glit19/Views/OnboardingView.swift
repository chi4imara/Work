import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage: Int = 0
    
    var body: some View {
        ZStack {
            Color.theme.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPage(
                        icon1: "lightbulb.fill",
                        icon2: "note.text",
                        title: "Collect every spark of inspiration.",
                        description: "Save your favorite quotes, ideas, and short notes in one organized space. Create categories, add new entries in seconds, and keep everything neatly structured. Build your personal inspiration journal where each thought stays easy to find and ready to revisit anytime.",
                        pageIndex: 0
                    )
                    .tag(0)
                    
                    OnboardingPage(
                        icon1: "folder.fill",
                        icon2: "tag.fill",
                        title: "Organize with categories.",
                        description: "Create custom categories to organize your notes exactly how you want. Group related ideas together, filter by category, and keep your inspiration library perfectly structured. Whether it's quotes, ideas, or reminders, everything has its place.",
                        pageIndex: 1
                    )
                    .tag(1)
                    
                    OnboardingPage(
                        icon1: "heart.fill",
                        icon2: "star.fill",
                        title: "Mark your favorites.",
                        description: "Never lose track of your most important notes. Mark any note as a favorite with a single tap, and access all your favorites instantly. Your best ideas, quotes, and thoughts are always just one click away.",
                        pageIndex: 2
                    )
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                Button(action: {
                    if currentPage < 2 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        UserDefaults.standard.set(true, forKey: "HasCompletedOnboarding")
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showOnboarding = false
                        }
                    }
                }) {
                    Text(currentPage < 2 ? "Next" : "Continue")
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(Color.theme.darkPink)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.theme.accentYellow)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            }
        }
    }
}

struct OnboardingPage: View {
    let icon1: String
    let icon2: String
    let title: String
    let description: String
    let pageIndex: Int
    
    var body: some View {
        VStack(spacing: 35) {
            Spacer()
            
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Color.theme.accentYellow.opacity(0.2))
                        .frame(width: 200, height: 200)
                    
                    VStack(spacing: 12) {
                        Image(systemName: icon1)
                            .font(.system(size: 60))
                            .foregroundColor(Color.theme.accentYellow)
                        
                        Image(systemName: icon2)
                            .font(.system(size: 40))
                            .foregroundColor(Color.theme.primaryText)
                    }
                }
            }
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.ubuntu(15))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
