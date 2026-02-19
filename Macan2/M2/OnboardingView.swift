import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    let onComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            title: "Capture your daily style",
            description: "Build your personal outfit diary and rediscover your sense of style day by day.",
            imageName: "figure.dress.line.vertical.figure"
        ),
        OnboardingPage(
            title: "Track your feelings",
            description: "Each entry helps you remember what you wore, how you felt, and how others reacted.",
            imageName: "heart.text.square"
        ),
        OnboardingPage(
            title: "Discover patterns",
            description: "Add short notes about comfort, mood, and details that make your look unique. Explore which outfits bring you confidence.",
            imageName: "chart.line.uptrend.xyaxis"
        ),
        OnboardingPage(
            title: "Your style timeline",
            description: "Keep your wardrobe memories organized in one elegant timeline — simple, personal, and made just for you.",
            imageName: "calendar.badge.clock"
        )
    ]
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
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
                                .fill(index == currentPage ? ColorManager.primaryText : ColorManager.neutralGray)
                                .frame(width: 8, height: 8)
                                .scaleEffect(index == currentPage ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    .padding(.bottom, 10)
                    
                    HStack(spacing: 20) {
                        if currentPage > 0 {
                            Button("Back") {
                                withAnimation {
                                    currentPage -= 1
                                }
                            }
                            .font(.playfairDisplay(16, weight: .medium))
                            .foregroundColor(ColorManager.secondaryText)
                        }
                        
                        Spacer()
                        
                        Button {
                            if currentPage == pages.count - 1 {
                                onComplete()
                            } else {
                                withAnimation {
                                    currentPage += 1
                                }
                            }
                        } label: {
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                                .font(.playfairDisplay(18, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 12)
                                .background(ColorManager.purpleGradient)
                                .cornerRadius(25)
                                .shadow(color: ColorManager.purpleDark.opacity(0.3), radius: 5, x: 0, y: 2)
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
                    if value.translation.width > 50 && currentPage > 0 {
                        withAnimation {
                            currentPage -= 1
                        }
                    } else if value.translation.width < -50 && currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
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
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorManager.primaryText)
                .padding(.bottom, 20)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.playfairDisplay(32, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.playfairDisplay(18, weight: .regular))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 30)
            }
            
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}

