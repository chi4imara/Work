import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: BeautyProductViewModel
    @State private var currentPage = 0
    
    private let colorManager = ColorManager.shared
    
    var body: some View {
        ZStack {
            colorManager.backgroundGradient
                .ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                OnboardingPageView(
                    title: "Your personal beauty discoveries",
                    description: "Keep track of every new product you try — from skincare to makeup and hair care.",
                    imageName: "sparkles",
                    currentPage: $currentPage,
                    totalPages: 2,
                    viewModel: viewModel
                )
                .tag(0)
                
                OnboardingPageView(
                    title: "Organize & Remember",
                    description: "Add short notes, impressions, and ratings to remember what worked best for you.\n\nGroup your experiences by category and revisit your favorite finds anytime.\n\nTurn your everyday experiments into a personalized beauty diary — simple, organized, and made just for you.",
                    imageName: "heart.fill",
                    currentPage: $currentPage,
                    totalPages: 2,
                    viewModel: viewModel
                )
                .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
}

struct OnboardingPageView: View {
    let title: String
    let description: String
    let imageName: String
    @Binding var currentPage: Int
    let totalPages: Int
    let viewModel: BeautyProductViewModel
    
    private let colorManager = ColorManager.shared
    
    var body: some View {
        VStack(spacing: 25) {
            Spacer()
            
            Image(systemName: imageName)
                .font(.system(size: 80))
                .foregroundColor(colorManager.primaryWhite)
                .shadow(color: colorManager.primaryPurple.opacity(0.3), radius: 10)
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.custom("PlayfairDisplay-Bold", size: 28))
                    .foregroundColor(colorManager.primaryWhite)
                    .multilineTextAlignment(.center)
                    .shadow(color: .black.opacity(0.2), radius: 2)
                
                Text(description)
                    .font(.custom("PlayfairDisplay-Regular", size: 16))
                    .foregroundColor(colorManager.primaryWhite)
                    .multilineTextAlignment(.center)
                    .lineSpacing(1)
                    .padding(.horizontal, 30)
                    .shadow(color: .black.opacity(0.2), radius: 1)
            }
            
            Spacer()
            
            VStack(spacing: 30) {
                HStack(spacing: 10) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? colorManager.primaryWhite : colorManager.primaryWhite.opacity(0.3))
                            .frame(width: 10, height: 10)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                
                Button(action: {
                    if currentPage < totalPages - 1 {
                        withAnimation(.easeInOut) {
                            currentPage += 1
                        }
                    } else {
                        viewModel.completeOnboarding()
                    }
                }) {
                    Text(currentPage == totalPages - 1 ? "Get Started" : "Continue")
                        .font(.custom("PlayfairDisplay-SemiBold", size: 18))
                        .foregroundColor(colorManager.secondaryText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(colorManager.primaryWhite)
                        .cornerRadius(25)
                        .shadow(color: .black.opacity(0.2), radius: 5)
                }
                .padding(.horizontal, 40)
            }
            .padding(.bottom, 50)
        }
    }
}

#Preview {
    OnboardingView(viewModel: BeautyProductViewModel())
}
