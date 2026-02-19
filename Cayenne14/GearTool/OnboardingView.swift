import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPage(
                        icon: "wrench.and.screwdriver",
                        title: "Keep your tools organized.",
                        description: "Create a clear catalog of all your tools with storage locations and usage dates. Add new items, review details anytime and mark when a tool was last used. A simple and structured way to keep your equipment in order and always know where everything is.",
                        pageIndex: 0
                    )
                    .tag(0)
                    
                    OnboardingPage(
                        icon: "list.bullet.rectangle",
                        title: "Track your usage.",
                        description: "Mark when you use each tool and keep a complete history. See which tools you use most frequently and identify items that haven't been used in a while. Stay organized and make informed decisions about your equipment.",
                        pageIndex: 1
                    )
                    .tag(1)
                    
                    OnboardingPage(
                        icon: "chart.bar.fill",
                        title: "Get insights.",
                        description: "View detailed analytics about your tool collection. See statistics by category, track usage patterns, and discover which tools are your favorites. Make the most of your equipment with comprehensive insights.",
                        pageIndex: 2
                    )
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? AppColors.lightBlue : AppColors.secondaryText.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                .padding(.bottom, 30)
                
                Button(action: {
                    if currentPage < 2 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    } else {
                        showOnboarding = false
                    }
                }) {
                    Text(currentPage < 2 ? "Next" : "Get Started")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(AppColors.lightBlue)
                        .cornerRadius(25)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
                .animation(.none, value: currentPage)
            }
        }
    }
}

struct OnboardingPage: View {
    let icon: String
    let title: String
    let description: String
    let pageIndex: Int
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardBackground)
                    .frame(width: 120, height: 120)
                
                Image(systemName: icon)
                    .font(.system(size: 50))
                    .foregroundColor(AppColors.orange)
            }
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
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
