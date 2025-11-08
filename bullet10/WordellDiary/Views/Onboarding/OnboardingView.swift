import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var dragOffset: CGSize = .zero
    
    var onComplete: () -> Void
    
    private let pages = OnboardingPage.allPages
    
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
                
                VStack(spacing: 30) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? AppColors.primaryBlue : AppColors.darkGray.opacity(0.3))
                                .frame(width: 10, height: 10)
                                .scaleEffect(index == currentPage ? 1.2 : 1.0)
                                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentPage)
                        }
                    }
                    
                    HStack {
                        if currentPage > 0 {
                            Button("Back") {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentPage -= 1
                                }
                            }
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.darkGray)
                        }
                        
                        Spacer()
                        
                        Button {
                            if currentPage == pages.count - 1 {
                                onComplete()
                            } else {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentPage += 1
                                }
                            }
                        } label: {
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                                .font(AppFonts.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 12)
                                .background {
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(
                                            LinearGradient(
                                                colors: [AppColors.primaryBlue, AppColors.accentYellow],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                }
                                .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 200, height: 200)
                    .shadow(color: AppColors.darkGray.opacity(0.1), radius: 20, x: 0, y: 10)
                
                Image(systemName: page.icon)
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(AppColors.primaryBlue)
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(AppFonts.title)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.primaryBlue)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.darkGray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 30)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let icon: String
    
    static let allPages = [
        OnboardingPage(
            title: "Describe Your Day. One Word Picture at a Time.",
            description: "This app turns your daily moments into a written diary — one entry a day, no photos, no distractions.",
            icon: "pencil.and.outline"
        ),
        OnboardingPage(
            title: "Capture What Mattered Most",
            description: "Every day, you can describe a small moment with words: a smell, a sound, a conversation, a feeling. Over time, these short texts become snapshots of your life.",
            icon: "heart.text.square"
        ),
        OnboardingPage(
            title: "Choose Your Mood",
            description: "Choose a mood that fits the day — joy, calm, sadness, love, or frustration — and capture what mattered most.",
            icon: "face.smiling"
        ),
        OnboardingPage(
            title: "Your Personal Timeline",
            description: "Each entry stays safely stored on your device, in chronological order, forming a simple but powerful timeline of your life.",
            icon: "timeline.selection"
        )
    ]
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
