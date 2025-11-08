import SwiftUI

struct ThemeGeneratorView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var isGenerating = false
    @State private var animateTheme = false
    @State private var showFeedback = false
    @State private var feedbackMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 40) {
                        VStack(spacing: 12) {
                            Text("Party Theme Generator")
                                .font(.theme.title2)
                                .foregroundColor(ColorTheme.textPrimary)
                                .multilineTextAlignment(.center)
                            
                            Text("Get creative ideas for your party atmosphere")
                                .font(.theme.callout)
                                .foregroundColor(ColorTheme.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                        .opacity(animateTheme ? 1.0 : 0.0)
                        
                        if let currentTheme = viewModel.currentTheme {
                            ThemeCard(theme: currentTheme, isAnimated: animateTheme)
                                .scaleEffect(animateTheme ? 1.0 : 0.8)
                                .opacity(animateTheme ? 1.0 : 0.0)
                        }
                        
                        VStack(spacing: 16) {
                            Button(action: generateTheme) {
                                HStack {
                                    if isGenerating {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: ColorTheme.textLight))
                                            .scaleEffect(0.8)
                                        Text("Generating...")
                                    } else {
                                        Image(systemName: "sparkles")
                                        Text("Generate New Theme")
                                    }
                                }
                                .font(.theme.headline)
                                .foregroundColor(ColorTheme.textLight)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    isGenerating ?
                                    AnyShapeStyle(ColorTheme.lightBlue.opacity(0.7)) :
                                    AnyShapeStyle(ColorTheme.buttonGradient)
                                )
                                .cornerRadius(28)
                                .shadow(color: ColorTheme.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
                            }
                            .disabled(isGenerating)
                            
                            if let currentTheme = viewModel.currentTheme {
                                Button(action: {
                                    saveToFavorites(theme: currentTheme)
                                }) {
                                    HStack {
                                        Image(systemName: "heart.fill")
                                        Text("Save to Favorites")
                                    }
                                    .font(.theme.callout)
                                    .foregroundColor(ColorTheme.accentPink)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(
                                        RoundedRectangle(cornerRadius: 22)
                                            .fill(ColorTheme.backgroundWhite)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 22)
                                            .stroke(ColorTheme.accentPink, lineWidth: 2)
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 40)
                        .opacity(animateTheme ? 1.0 : 0.0)
                        
                        if viewModel.statistics.themesGenerated > 0 {
                            VStack(spacing: 12) {
                                Text("Generated Themes")
                                    .font(.theme.headline)
                                    .foregroundColor(ColorTheme.textPrimary)
                                
                                Text("\(viewModel.statistics.themesGenerated)")
                                    .font(.theme.largeTitle)
                                    .foregroundColor(ColorTheme.primaryBlue)
                            }
                            .padding(.vertical, 20)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(ColorTheme.backgroundWhite)
                                    .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
                            )
                            .padding(.horizontal, 40)
                            .opacity(animateTheme ? 1.0 : 0.0)
                        }
                        
                        Spacer(minLength: 100)
                    }
                }
                
                if showFeedback {
                    VStack {
                        Spacer()
                        
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(ColorTheme.accentGreen)
                            Text(feedbackMessage)
                                .font(.theme.callout)
                                .foregroundColor(ColorTheme.textPrimary)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(ColorTheme.backgroundWhite)
                                .shadow(color: ColorTheme.primaryBlue.opacity(0.2), radius: 10, x: 0, y: 5)
                        )
                        .padding(.bottom, 100)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .navigationTitle("Themes")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                animateTheme = true
            }
        }
    }
    
    private func generateTheme() {
        guard !isGenerating else { return }
        
        isGenerating = true
        
        withAnimation(.easeInOut(duration: 0.3)) {
            animateTheme = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            viewModel.generateNewTheme()
            
            withAnimation(.easeOut(duration: 0.5)) {
                animateTheme = true
            }
            
            isGenerating = false
        }
    }
    
    private func saveToFavorites(theme: PartyTheme) {
        let themeText = "\(theme.title) - \(theme.description)"
        let success = viewModel.addToFavorites(text: themeText, type: .theme)
        
        feedbackMessage = success ? "Added to favorites!" : "Already in favorites"
        
        withAnimation(.easeInOut(duration: 0.3)) {
            showFeedback = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showFeedback = false
            }
        }
    }
}

struct ThemeCard: View {
    let theme: PartyTheme
    let isAnimated: Bool
    @State private var cardRotation: Double = 0
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                ColorTheme.accentPurple.opacity(0.8),
                                ColorTheme.primaryBlue.opacity(0.6)
                            ],
                            center: .center,
                            startRadius: 20,
                            endRadius: 60
                        )
                    )
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(cardRotation))
                
                Image(systemName: "theatermasks.fill")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(ColorTheme.textLight)
            }
            
            VStack(spacing: 12) {
                Text(theme.title)
                    .font(.theme.title2)
                    .foregroundColor(ColorTheme.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(theme.description)
                    .font(.theme.body)
                    .foregroundColor(ColorTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 40)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(ColorTheme.backgroundWhite)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.15), radius: 15, x: 0, y: 8)
        )
        .padding(.horizontal, 20)
        .onAppear {
            if isAnimated {
                withAnimation(
                    Animation.linear(duration: 10)
                        .repeatForever(autoreverses: false)
                ) {
                    cardRotation = 360
                }
            }
        }
    }
}

#Preview {
    ThemeGeneratorView(viewModel: AppViewModel())
}
