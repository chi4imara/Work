import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showMainApp = false
    
    var onComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            title: "Build Your Word Collection",
            description: "This app lets you collect new words, one day at a time. Each day you can add a word in any language, with its translation and notes if you like.",
            imageName: "book.fill"
        ),
        OnboardingPage(
            title: "Personal Dictionary",
            description: "Over time, you'll build your own personalized dictionary to revisit and grow. It's simple, private, and focused on your learning journey.",
            imageName: "heart.text.square.fill"
        ),
        OnboardingPage(
            title: "Start Today",
            description: "Ready to begin your word collection journey? Add your first word and start building your personal vocabulary.",
            imageName: "star.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
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
                                .fill(index == currentPage ? AppColors.primaryBlue : AppColors.lightBlue)
                                .frame(width: 10, height: 10)
                                .scaleEffect(index == currentPage ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    HStack(spacing: 20) {
                        if currentPage > 0 {
                            PixelButton(
                                title: "Back",
                                action: {
                                    withAnimation {
                                        currentPage -= 1
                                    }
                                },
                                color: AppColors.secondaryText
                            )
                            
                            Spacer()
                        }
                        
                        if currentPage < pages.count - 1 {
                            PixelButton(
                                title: "Next",
                                action: {
                                    withAnimation {
                                        currentPage += 1
                                    }
                                },
                                color: AppColors.primaryBlue
                            )
                        } else {
                            PixelButton(
                                title: "Get Started",
                                action: {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        onComplete()
                                    }
                                },
                                color: AppColors.darkBlue
                            )
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.bottom, 50)
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -50 && currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else if value.translation.width > 50 && currentPage > 0 {
                        withAnimation {
                            currentPage -= 1
                        }
                    }
                }
        )
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var animateIcon = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.lightBlue.opacity(0.3))
                    .frame(width: 120, height: 120)
                    .scaleEffect(animateIcon ? 1.1 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 2)
                            .repeatForever(autoreverses: true),
                        value: animateIcon
                    )
                
                Image(systemName: page.imageName)
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(AppColors.primaryBlue)
            }
            .onAppear {
                animateIcon = true
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(FontManager.largeTitle)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(FontManager.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 30)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
