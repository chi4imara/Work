import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Binding var isCompleted: Bool
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    ForEach(0..<viewModel.pages.count, id: \.self) { index in
                        Capsule()
                            .fill(index <= viewModel.currentPage ? AppColors.primaryOrange : AppColors.mediumGray)
                            .frame(height: 4)
                            .animation(.easeInOut(duration: 0.3), value: viewModel.currentPage)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.top, 20)
                
                TabView(selection: $viewModel.currentPage) {
                    ForEach(0..<viewModel.pages.count, id: \.self) { index in
                        OnboardingPageView(page: viewModel.pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: viewModel.currentPage)
                
                HStack {
                    if viewModel.currentPage > 0 {
                        Button("Back") {
                            viewModel.previousPage()
                        }
                        .font(.playfairMedium(size: 16))
                        .foregroundColor(AppColors.primaryNavy)
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                    
                    Spacer()
                    
                    Button {
                        if viewModel.currentPage == viewModel.pages.count - 1 {
                            viewModel.completeOnboarding()
                            withAnimation(.easeInOut(duration: 0.5)) {
                                isCompleted = true
                            }
                        } else {
                            viewModel.nextPage()
                        }
                    } label: {
                        Text(viewModel.currentPage == viewModel.pages.count - 1 ? "Get Started" : "Continue")
                            .font(.playfairSemiBold(size: 16))
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [AppColors.primaryOrange, AppColors.lightBlue]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(25)
                            .shadow(color: AppColors.primaryOrange.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width > 50 && viewModel.currentPage > 0 {
                        viewModel.previousPage()
                    } else if value.translation.width < -50 && viewModel.currentPage < viewModel.pages.count - 1 {
                        viewModel.nextPage()
                    }
                }
        )
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.system(size: 80))
                .foregroundColor(AppColors.primaryOrange)
                .shadow(color: AppColors.primaryOrange.opacity(0.3), radius: 20, x: 0, y: 10)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.playfairBold(size: 28))
                    .foregroundColor(AppColors.primaryNavy)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Text(page.description)
                    .font(.playfairRegular(size: 18))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 30)
            }
            
            Spacer()
            Spacer()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(isCompleted: .constant(false))
    }
}
