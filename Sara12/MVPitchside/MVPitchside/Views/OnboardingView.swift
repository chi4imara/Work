import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    var onComplete: () -> Void
    
    var body: some View {
        ZStack {
            AppGradient.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button("Skip") {
                        viewModel.completeOnboarding()
                        onComplete()
                    }
                    .font(.callout)
                    .foregroundColor(.secondaryText)
                    .padding(.trailing, 20)
                    .padding(.top, 10)
                }
                
                TabView(selection: $viewModel.currentPage) {
                    ForEach(0..<viewModel.onboardingPages.count, id: \.self) { index in
                        OnboardingPageView(page: viewModel.onboardingPages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: viewModel.currentPage)
                
                HStack(spacing: 8) {
                    ForEach(0..<viewModel.onboardingPages.count, id: \.self) { index in
                        Circle()
                            .fill(index == viewModel.currentPage ? Color.primaryAccent : Color.secondaryText.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .scaleEffect(index == viewModel.currentPage ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: viewModel.currentPage)
                    }
                }
                .padding(.vertical, 20)
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        if viewModel.currentPage == viewModel.onboardingPages.count - 1 {
                            viewModel.completeOnboarding()
                            onComplete()
                        } else {
                            viewModel.nextPage()
                        }
                    }
                }) {
                    Text(viewModel.currentPage == viewModel.onboardingPages.count - 1 ? "Get Started" : "Continue")
                        .font(.buttonText)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.primaryAccent)
                        .cornerRadius(25)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.custom("Poppins-Light", size: 80))
                .foregroundColor(.primaryAccent)
                .padding(.bottom, 20)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.title1)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Text(page.description)
                    .font(.body)
                    .foregroundColor(.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 30)
            }
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(viewModel: OnboardingViewModel()) {
        print("Onboarding completed")
    }
}
