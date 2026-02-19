import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    
    private let totalPages = 3
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            TabView(selection: $currentPage) {
                OnboardingPage(
                    title: "Track what you try and what happens.",
                    description: "This app helps you record personal experiments in a clear and simple format.",
                    systemImage: "flask",
                    showContinueOnly: false
                )
                .tag(0)
                
                OnboardingPage(
                    title: "Simple Structure",
                    description: "Write down what you tried, what you changed, and what result you got. It's a structured way to capture outcomes of your own experiments.",
                    systemImage: "doc.text",
                    showContinueOnly: false
                )
                .tag(1)
                
                OnboardingPage(
                    title: "Clear Facts",
                    description: "Keep facts clear and easy to revisit without analysis or interpretation.",
                    systemImage: "checkmark.circle",
                    showContinueOnly: false
                )
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            VStack {
                Spacer()
                
                HStack(spacing: 16) {
                    Button(action: {
                        if currentPage > 0 {
                            withAnimation {
                                currentPage -= 1
                            }
                        }
                    }) {
                        Text("Back")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(Color.theme.secondaryButtonText)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.theme.secondaryButtonBackground)
                            .cornerRadius(12)
                    }
                    .opacity(currentPage > 0 ? 1 : 0.5)
                    .disabled(currentPage == 0)
                    
                    Button(action: {
                        if currentPage < totalPages - 1 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            showOnboarding = true
                        }
                    }) {
                        Text(currentPage < totalPages - 1 ? "Continue" : "Continue")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(Color.theme.buttonText)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.theme.buttonBackground)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPage: View {
    let title: String
    let description: String
    let systemImage: String
    let showContinueOnly: Bool
    var buttonAction: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: systemImage)
                .font(.system(size: 80))
                .foregroundColor(Color.theme.primaryYellow)
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.ubuntu(18))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            
            if showContinueOnly {
                Button(action: {
                    buttonAction?()
                }) {
                    Text("Continue")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(Color.theme.buttonText)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.theme.buttonBackground)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            } else {
                Spacer()
                    .frame(height: 100)
            }
        }
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
