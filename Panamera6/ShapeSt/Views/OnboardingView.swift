import SwiftUI

struct OnboardingView: View {
    let onComplete: () -> Void
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPage(
                        icon: "scissors",
                        icon2: "person.crop.rectangle",
                        title: "Build your personal style archive.",
                        description: "Keep all your haircut and beard ideas in one clear, organized place. Save styles with length, shape, and notes, mark your favorites, and browse categories for quick inspiration. Create a personal archive you can open anytime to choose the perfect look.",
                        pageIndex: 0
                    )
                    
                    OnboardingPage(
                        icon: "folder.fill",
                        icon2: "heart.fill",
                        title: "Organize and categorize.",
                        description: "Easily organize your styles by category, length, and shape. Mark your favorite looks for quick access. Browse through your collection with powerful search and filter options.",
                        pageIndex: 1
                    )
                    
                    OnboardingPage(
                        icon: "star.fill",
                        icon2: "chart.bar.fill",
                        title: "Track your style journey.",
                        description: "View statistics about your style collection, track your preferences, and discover patterns in your choices. Build a comprehensive archive that grows with you.",
                        pageIndex: 2
                    )
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? ColorTheme.orange : ColorTheme.white.opacity(0.3))
                            .frame(width: 10, height: 10)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 30)
                
                Button(action: {
                    if currentPage < 2 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        onComplete()
                    }
                }) {
                    HStack {
                        Text(currentPage < 2 ? "Next" : "Continue")
                            .font(.lumierepolis(size: 18, weight: .bold))
                            .foregroundColor(ColorTheme.white)
                        
                        Image(systemName: currentPage < 2 ? "arrow.right" : "checkmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(ColorTheme.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(ColorTheme.orange)
                    )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
    }
}

struct OnboardingPage: View {
    let icon: String
    let icon2: String
    let title: String
    let description: String
    let pageIndex: Int
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(ColorTheme.white.opacity(0.1))
                        .frame(width: 190, height: 190)
                    
                    VStack(spacing: 12) {
                        Image(systemName: icon)
                            .font(.system(size: 40, weight: .light))
                            .foregroundColor(ColorTheme.orange)
                        
                        Image(systemName: icon2)
                            .font(.system(size: 30, weight: .light))
                            .foregroundColor(ColorTheme.white)
                    }
                }
            }
            
            VStack(spacing: 16) {
                Text(title)
                    .font(.lumierepolis(size: 28, weight: .bold))
                    .foregroundColor(ColorTheme.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(description)
                    .font(.lumierepolis(size: 16))
                    .foregroundColor(ColorTheme.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .tag(pageIndex)
    }
}
