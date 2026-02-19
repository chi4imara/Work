import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: DeviceViewModel
    @State private var currentPage = 0
    
    private let totalPages = 4
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPage1()
                        .tag(0)
                    
                    OnboardingPage2()
                        .tag(1)
                    
                    OnboardingPage3()
                        .tag(2)
                    
                    OnboardingPage4()
                        .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                HStack(spacing: 8) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? AppColors.accentBlue : AppColors.secondaryText.opacity(0.3))
                            .frame(width: currentPage == index ? 10 : 8, height: currentPage == index ? 10 : 8)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                .padding(.bottom, 20)
                
                HStack(spacing: 16) {
                    if currentPage > 0 {
                        Button(action: {
                            withAnimation {
                                currentPage -= 1
                            }
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Previous")
                            }
                            .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                            .foregroundColor(AppColors.primaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(AppColors.secondaryBackground.opacity(0.6))
                            .cornerRadius(12)
                        }
                    } else {
                        Spacer()
                            .frame(maxWidth: .infinity)
                    }
                    
                    if currentPage < totalPages - 1 {
                        Button(action: {
                            withAnimation {
                                currentPage += 1
                            }
                        }) {
                            HStack {
                                Text("Next")
                                Image(systemName: "chevron.right")
                            }
                            .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                LinearGradient(
                                    colors: [AppColors.accentBlue, AppColors.accentPurple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                        }
                    } else {
                        Button(action: {
                            viewModel.completeOnboarding()
                        }) {
                            HStack {
                                Text("Get Started")
                                Image(systemName: "arrow.right")
                            }
                            .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                LinearGradient(
                                    colors: [AppColors.accentBlue, AppColors.accentPurple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage1: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 180, height: 180)
                
                Image(systemName: "laptopcomputer.and.iphone")
                    .font(.system(size: 70))
                    .foregroundColor(AppColors.accentBlue)
            }
            
            VStack(spacing: 20) {
                Text("Keep your tech collection organized.")
                    .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("This app helps you track all your devices and gadgets in one place. Add purchase dates, write down technical details and keep your collection structured. A clear way to remember what you own, where each device belongs and how it fits into your setup.")
                    .font(FontManager.playfairDisplay(size: 15, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
    }
}

struct OnboardingPage2: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppColors.accentOrange.opacity(0.3), AppColors.accentPurple.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 180, height: 180)
                
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 70))
                    .foregroundColor(AppColors.accentOrange)
            }
            
            VStack(spacing: 20) {
                Text("Track Everything")
                    .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Easily add devices with detailed information. Record purchase dates, technical specifications, current condition, and personal notes. Keep a complete history of all your tech in one organized place.")
                    .font(FontManager.playfairDisplay(size: 15, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
    }
}

struct OnboardingPage3: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppColors.accentGreen.opacity(0.3), AppColors.accentBlue.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 180, height: 180)
                
                Image(systemName: "folder.fill")
                    .font(.system(size: 70))
                    .foregroundColor(AppColors.accentGreen)
            }
            
            VStack(spacing: 20) {
                Text("Organize by Categories")
                    .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Categorize your devices into Phones, Computers, Electronics, Tools, and more. Use filters to quickly find what you need. View detailed characteristics grouped by category for better organization.")
                    .font(FontManager.playfairDisplay(size: 15, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
    }
}

struct OnboardingPage4: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppColors.accentPurple.opacity(0.3), AppColors.accentOrange.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 180, height: 180)
                
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 70))
                    .foregroundColor(AppColors.accentPurple)
            }
            
            VStack(spacing: 20) {
                Text("Stay Informed")
                    .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Get insights about your collection with analytics and statistics. Monitor device conditions, track categories, and maintain your tech inventory efficiently. Start building your digital catalog today!")
                    .font(FontManager.playfairDisplay(size: 15, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(viewModel: DeviceViewModel())
}
