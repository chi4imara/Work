import SwiftUI

struct QuotesView: View {
    @StateObject private var quoteManager = QuoteManager.shared
    @State private var quoteScale: CGFloat = 0.8
    @State private var quoteOpacity: Double = 0.0
    @State private var buttonScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 40) {
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(Color.theme.accentGold.opacity(0.2))
                                .frame(width: 60, height: 60)
                                .offset(x: -10, y: -5)
                            
                            Circle()
                                .fill(Color.theme.primaryPurple.opacity(0.2))
                                .frame(width: 40, height: 40)
                                .offset(x: 15, y: 8)
                            
                            Image(systemName: "quote.bubble")
                                .font(.system(size: 32, weight: .light))
                                .foregroundColor(Color.theme.primaryWhite)
                        }
                        
                        Text("Mindful Quotes")
                            .font(.ubuntu(28, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                    }
                    .padding(.top, 60)
                    
                    VStack(spacing: 0) {
                        HStack {
                            Text("Quote \(quoteManager.currentIndex + 1) of \(quoteManager.quotesCount)")
                                .font(.ubuntu(12, weight: .light))
                                .foregroundColor(Color.theme.secondaryText)
                            Spacer()
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 10)
                        
                        VStack(spacing: 25) {
                            HStack {
                                Image(systemName: "quote.opening")
                                    .font(.system(size: 24, weight: .light))
                                    .foregroundColor(Color.theme.accentGold.opacity(0.6))
                                
                                Spacer()
                                
                                Image(systemName: "quote.closing")
                                    .font(.system(size: 24, weight: .light))
                                    .foregroundColor(Color.theme.accentGold.opacity(0.6))
                            }
                            .padding(.horizontal, 20)
                            
                            Text(quoteManager.currentQuote.text)
                                .font(.ubuntu(20, weight: .light))
                                .foregroundColor(Color.theme.primaryText)
                                .multilineTextAlignment(.center)
                                .lineSpacing(8)
                                .padding(.horizontal, 30)
                                .scaleEffect(quoteScale)
                                .opacity(quoteOpacity)
                            
                            VStack(spacing: 8) {
                                Rectangle()
                                    .fill(Color.theme.accentGold.opacity(0.3))
                                    .frame(width: 40, height: 1)
                                
                                Text("— " + quoteManager.currentQuote.author)
                                    .font(.ubuntuItalic(16, weight: .light))
                                    .foregroundColor(Color.theme.secondaryText)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.top, 10)
                        }
                        .padding(.vertical, 40)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.theme.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(
                                            LinearGradient(
                                                colors: [Color.theme.accentGold.opacity(0.3), Color.theme.primaryPurple.opacity(0.3)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1
                                        )
                                )
                                .shadow(
                                    color: Color.theme.primaryPurple.opacity(0.1),
                                    radius: 20,
                                    x: 0,
                                    y: 10
                                )
                        )
                        .padding(.horizontal, 20)
                    }
                    
                    VStack(spacing: 20) {
                        HStack(spacing: 6) {
                            ForEach(0..<10, id: \.self) { index in
                                Circle()
                                    .fill(index == quoteManager.currentIndex ? Color.theme.accentGold : Color.theme.primaryWhite.opacity(0.3))
                                    .frame(width: 8, height: 8)
                                    .scaleEffect(index == quoteManager.currentIndex ? 1.2 : 1.0)
                                    .animation(.easeInOut(duration: 0.3), value: quoteManager.currentIndex)
                            }
                        }
                        
                        HStack(spacing: 30) {
                            QuoteNavigationButton(
                                title: "Previous",
                                icon: "chevron.left",
                                isEnabled: true,
                                action: {
                                    withAnimation(.easeInOut(duration: 0.4)) {
                                        quoteManager.previousQuote()
                                        updateQuoteAnimation()
                                    }
                                }
                            )
                            
                            QuoteNavigationButton(
                                title: "Next",
                                icon: "chevron.right",
                                isEnabled: true,
                                action: {
                                    withAnimation(.easeInOut(duration: 0.4)) {
                                        quoteManager.nextQuote()
                                        updateQuoteAnimation()
                                    }
                                }
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 100)
                }
            }
        }
        .onAppear {
            updateQuoteAnimation()
        }
    }
    
    private func updateQuoteAnimation() {
        quoteScale = 0.8
        quoteOpacity = 0.0
        
        withAnimation(.easeOut(duration: 0.3)) {
            quoteScale = 1.0
            quoteOpacity = 1.0
        }
    }
}

struct QuoteNavigationButton: View {
    let title: String
    let icon: String
    let isEnabled: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
                action()
            }
        }) {
            HStack(spacing: 8) {
                if title == "Previous" {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                    Text(title)
                        .font(.ubuntu(16, weight: .medium))
                } else {
                    Text(title)
                        .font(.ubuntu(16, weight: .medium))
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                }
            }
            .foregroundColor(Color.theme.primaryText)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.theme.primaryPurple.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.theme.primaryWhite.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(
                        color: Color.theme.primaryPurple.opacity(0.2),
                        radius: isPressed ? 5 : 10,
                        x: 0,
                        y: isPressed ? 2 : 5
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.6)
    }
}

#Preview {
    QuotesView()
}
