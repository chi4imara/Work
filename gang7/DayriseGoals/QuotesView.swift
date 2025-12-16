import SwiftUI

struct QuotesView: View {
    @ObservedObject var quotesViewModel: QuotesViewModel
    @State private var isAnimating = false
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var pulseScale: CGFloat = 1.0
    @State private var quoteOffset: CGFloat = 0
    @State private var sparkleRotation: Double = 0
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            if AppData.quotes.isEmpty {
                EmptyQuotesView()
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Spacer(minLength: 60)
                        
                        VStack(spacing: 30) {
                            HStack(spacing: 40) {
                                ForEach(0..<5) { index in
                                    Image(systemName: "sparkle")
                                        .font(.system(size: 16 + CGFloat(index * 2)))
                                        .foregroundColor(AppColors.textYellow.opacity(0.7))
                                        .rotationEffect(.degrees(sparkleRotation + Double(index * 45)))
                                        .offset(
                                            x: sin(Double(index) * 0.8 + rotationAngle * 0.1) * 15,
                                            y: cos(Double(index) * 0.6 + rotationAngle * 0.1) * 10
                                        )
                                        .animation(
                                            .easeInOut(duration: 3 + Double(index) * 0.5)
                                            .repeatForever(autoreverses: true)
                                            .delay(Double(index) * 0.3),
                                            value: sparkleRotation
                                        )
                                }
                            }
                            
                            ZStack {
                                ForEach(0..<3) { index in
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    AppColors.elementPurple.opacity(0.2),
                                                    AppColors.warmOrange.opacity(0.2),
                                                    AppColors.softGreen.opacity(0.2)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1
                                        )
                                        .frame(width: 200 + CGFloat(index * 100), height: 200 + CGFloat(index * 100))
                                        .rotationEffect(.degrees(rotationAngle + Double(index * 60)))
                                        .animation(
                                            .linear(duration: 20 + Double(index * 5))
                                            .repeatForever(autoreverses: false),
                                            value: rotationAngle
                                        )
                                }
                                
                                VStack(spacing: 30) {
                                    HStack {
                                        Image(systemName: "quote.opening")
                                            .font(.system(size: 24))
                                            .foregroundColor(AppColors.elementPurple.opacity(0.6))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "quote.closing")
                                            .font(.system(size: 24))
                                            .foregroundColor(AppColors.warmOrange.opacity(0.6))
                                    }
                                    .padding(.horizontal, 20)
                                    
                                    Text(quotesViewModel.currentQuote.text)
                                        .font(.ubuntu(22, weight: .light))
                                        .foregroundColor(AppColors.primaryText)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 40)
                                        .opacity(isAnimating ? 1 : 0.7)
                                        .scaleEffect(isAnimating ? 1 : 0.95)
                                        .offset(y: quoteOffset)
                                    
                                    Text("— \(quotesViewModel.currentQuote.author)")
                                        .font(.ubuntuItalic(18, weight: .light))
                                        .foregroundColor(AppColors.secondaryText)
                                        .multilineTextAlignment(.center)
                                        .opacity(isAnimating ? 1 : 0.7)
                                        .offset(y: quoteOffset)
                                }
                                .padding(.vertical, 40)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(AppColors.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 25)
                                                .stroke(
                                                    LinearGradient(
                                                        colors: [
                                                            AppColors.elementPurple.opacity(0.3),
                                                            AppColors.warmOrange.opacity(0.3)
                                                        ],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ),
                                                    lineWidth: 2
                                                )
                                        )
                                        .shadow(
                                            color: AppColors.elementPurple.opacity(0.2),
                                            radius: 10,
                                            x: 0,
                                            y: 5
                                        )
                                )
                                .padding(.horizontal, 30)
                                .scaleEffect(pulseScale)
                                .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: pulseScale)
                            }
                            .animation(.easeInOut(duration: 0.5), value: quotesViewModel.currentQuoteIndex)
                            
                            HStack(spacing: 40) {
                                NavigationButton(
                                    icon: "chevron.left",
                                    title: "Previous",
                                    action: {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            isAnimating = false
                                            quoteOffset = -20
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            quotesViewModel.previousQuote()
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                isAnimating = true
                                                quoteOffset = 0
                                            }
                                        }
                                    }
                                )
                                
                                NavigationButton(
                                    icon: "chevron.right",
                                    title: "Next",
                                    action: {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            isAnimating = false
                                            quoteOffset = 20
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            quotesViewModel.nextQuote()
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                isAnimating = true
                                                quoteOffset = 0
                                            }
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 25) {
                            HStack(spacing: 20) {
                                ForEach(0..<7) { index in
                                    Circle()
                                        .fill(AppColors.textYellow.opacity(0.4))
                                        .frame(width: 6, height: 6)
                                        .offset(
                                            x: sin(Double(index) * 0.5 + rotationAngle * 0.05) * 15,
                                            y: cos(Double(index) * 0.7 + rotationAngle * 0.05) * 8
                                        )
                                        .animation(
                                            .easeInOut(duration: 2.5)
                                            .repeatForever(autoreverses: true)
                                            .delay(Double(index) * 0.2),
                                            value: rotationAngle
                                        )
                                }
                            }
                            
                            Text("Words have the power to transform your morning")
                                .font(.ubuntuItalic(16, weight: .light))
                                .foregroundColor(AppColors.secondaryText)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        .padding(.top, 40)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                isAnimating = true
                scale = 1.0
                rotationAngle = 360
                pulseScale = 1.05
                sparkleRotation = 360
            }
        }
    }
}

struct NavigationButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    @State private var isPressed = false
    @State private var glowIntensity: Double = 0.3
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(
                        RadialGradient(
                            colors: [
                                AppColors.elementPurple.opacity(glowIntensity),
                                AppColors.warmOrange.opacity(glowIntensity * 0.5),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 10,
                            endRadius: 50
                        )
                    )
                    .frame(width: 120, height: 60)
                    .blur(radius: 8)
                
                HStack(spacing: 8) {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                    Text(title)
                        .font(.ubuntu(16, weight: .medium))
                }
                .foregroundColor(AppColors.elementPurple)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            AppColors.elementPurple.opacity(0.6),
                                            AppColors.warmOrange.opacity(0.4)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                        .shadow(
                            color: AppColors.elementPurple.opacity(0.4),
                            radius: isPressed ? 4 : 8,
                            x: 0,
                            y: isPressed ? 2 : 4
                        )
                )
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                glowIntensity = 0.8
            }
        }
    }
}

struct EmptyQuotesView: View {
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 0.8
    
    var body: some View {
        VStack(spacing: 30) {
            ZStack {
                ForEach(0..<6) { index in
                    Image(systemName: "star.fill")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.textYellow.opacity(0.6))
                        .offset(
                            x: cos(Double(index) * 60 * .pi / 180 + rotationAngle) * 40,
                            y: sin(Double(index) * 60 * .pi / 180 + rotationAngle) * 40
                        )
                        .animation(
                            .linear(duration: 10)
                            .repeatForever(autoreverses: false),
                            value: rotationAngle
                        )
                }
                
                Image(systemName: "moon.zzz")
                    .font(.system(size: 60))
                    .foregroundColor(AppColors.secondaryText.opacity(0.6))
                    .scaleEffect(scale)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: scale)
            }
            .frame(width: 120, height: 120)
            
            VStack(spacing: 15) {
                Text("Today the quotes are still sleeping.")
                    .font(.ubuntu(22, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Try again later.")
                    .font(.ubuntu(18, weight: .light))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
        }
        .onAppear {
            withAnimation {
                scale = 1.0
                rotationAngle = 360
            }
        }
    }
}

#Preview {
    QuotesView(quotesViewModel: QuotesViewModel())
}
