import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var showOnboarding: Bool
    
    private let pages = [
        OnboardingPage(
            title: "Fix it yourself. Step by step.",
            description: "Small home problems don't have to turn into big expenses. This app is your pocket guide to simple household repairs and improvements.",
            imageName: "house.fill",
            backgroundColor: Color.primaryBlue
        ),
        OnboardingPage(
            title: "Clear Instructions",
            description: "Browse a collection of clear, structured instructions: how to fix a leaking tap, replace a light bulb, assemble furniture, or take care of your garden tools.",
            imageName: "list.clipboard.fill",
            backgroundColor: Color.darkBlue
        ),
        OnboardingPage(
            title: "Everything in One Place",
            description: "No more endless searches online, no more confusion — everything you need is in one place, always at hand. You can also save useful instructions to your archive to revisit them whenever you need.",
            imageName: "archivebox.fill",
            backgroundColor: Color.accentOrange
        ),
        OnboardingPage(
            title: "Learn and Save",
            description: "With this app, you'll feel more confident at home, learn new skills, and keep your space in order without stress or extra costs.",
            imageName: "star.fill",
            backgroundColor: Color.accentGreen
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.primaryBlue : Color.gray.opacity(0.3))
                            .frame(width: 10, height: 10)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                .padding(.top, 50)
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        showOnboarding = false
                    }
                }) {
                    Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primaryBlue)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
    let backgroundColor: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(page.backgroundColor.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: page.imageName)
                    .font(.system(size: 50))
                    .foregroundColor(page.backgroundColor)
            }
            
            Text(page.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            Text(page.description)
                .font(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .padding(.horizontal, 30)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}

