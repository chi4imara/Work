import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: BagViewModel
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPageView(
                        title: "Organize your bags by occasion",
                        description: "Create a clear organizer for your bags based on how you use them. Assign each bag to a scenario like day, evening, or travel, and add notes about what fits best.",
                        imageName: "bag",
                        showButton: false,
                        currentPage: $currentPage,
                        totalPages: 4
                    )
                    .tag(0)
                    
                    OnboardingPageView(
                        title: "Smart Organization",
                        description: "Over time, this collection becomes a practical reference for choosing the right bag for every situation.",
                        imageName: "list.bullet.clipboard",
                        showButton: false,
                        currentPage: $currentPage,
                        totalPages: 4
                    )
                    .tag(1)
                    
                    OnboardingPageView(
                        title: "Track Your Collection",
                        description: "Keep track of all your bags in one place. View statistics, manage favorites, and organize by usage scenarios.",
                        imageName: "chart.bar",
                        showButton: false,
                        currentPage: $currentPage,
                        totalPages: 4
                    )
                    .tag(2)
                    
                    OnboardingPageView(
                        title: "Get Started",
                        description: "Start organizing your bags today. Add your first bag and begin building your collection.",
                        imageName: "checkmark.circle",
                        showButton: false,
                        currentPage: $currentPage,
                        totalPages: 4
                    )
                    .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack(spacing: 15) {
                    if currentPage > 0 {
                        Button(action: {
                            withAnimation {
                                currentPage -= 1
                            }
                        }) {
                            Text("Previous")
                                .font(.bellGothicBold(size: 16))
                                .foregroundColor(Color.theme.textWhite)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.theme.cardBackground)
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.theme.cardBorder, lineWidth: 1)
                                )
                        }
                    }
                    
                    Button(action: {
                        if currentPage < 3 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            viewModel.completeOnboarding()
                        }
                    }) {
                        Text(currentPage < 3 ? "Next" : "Get Started")
                            .font(.bellGothicBold(size: 16))
                            .foregroundColor(Color.theme.darkBlue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.theme.buttonGradient)
                            .cornerRadius(25)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
                
                PageIndicator(currentPage: currentPage, totalPages: 4)
                    .padding(.bottom, 20)
            }
        }
    }
}

struct OnboardingPageView: View {
    let title: String
    let description: String
    let imageName: String
    let showButton: Bool
    @Binding var currentPage: Int
    let totalPages: Int
    let buttonAction: (() -> Void)?
    
    init(title: String, description: String, imageName: String, showButton: Bool, currentPage: Binding<Int>, totalPages: Int, buttonAction: (() -> Void)? = nil) {
        self.title = title
        self.description = description
        self.imageName = imageName
        self.showButton = showButton
        self._currentPage = currentPage
        self.totalPages = totalPages
        self.buttonAction = buttonAction
    }
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(Color.theme.accentYellow)
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.bellGothicBold(size: 28))
                    .foregroundColor(Color.theme.textWhite)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text(description)
                    .font(.bellGothicRegular(size: 16))
                    .foregroundColor(Color.theme.textGray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .lineSpacing(4)
            }
            
            Spacer()
        }
    }
}

struct PageIndicator: View {
    let currentPage: Int
    let totalPages: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? Color.theme.accentYellow : Color.theme.textGray.opacity(0.3))
                    .frame(width: 10, height: 10)
                    .animation(.easeInOut, value: currentPage)
            }
        }
    }
}

#Preview {
    OnboardingView(viewModel: BagViewModel())
}
