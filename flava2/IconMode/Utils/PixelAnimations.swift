import SwiftUI

struct PixelAnimations {
    static let pixelBounce = Animation.easeInOut(duration: 0.3)
        .repeatCount(3, autoreverses: true)
    
    static let retroFade = Animation.easeInOut(duration: 0.5)
    
    static let pixelPulse = Animation.easeInOut(duration: 1.0)
        .repeatForever(autoreverses: true)
    
    static let pixelSlide = Animation.easeInOut(duration: 0.4)
    
    static let retroScale = Animation.spring(response: 0.6, dampingFraction: 0.8)
}

extension AnyTransition {
    static var pixelSlide: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        )
    }
    
    static var retroFade: AnyTransition {
        .opacity.combined(with: .scale(scale: 0.8))
    }
    
    static var pixelPop: AnyTransition {
        .scale(scale: 0.1).combined(with: .opacity)
    }
}

struct PixelLoadingView: View {
    @State private var isAnimating = false
    let dotCount: Int
    let color: Color
    
    init(dotCount: Int = 3, color: Color = AppColors.primary) {
        self.dotCount = dotCount
        self.color = color
    }
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<dotCount, id: \.self) { index in
                Rectangle()
                    .fill(color)
                    .frame(width: 8, height: 8)
                    .opacity(isAnimating ? 1.0 : 0.3)
                    .animation(
                        .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct PixelSuccessView: View {
    @State private var showCheckmark = false
    @State private var showRing = false
    let size: CGFloat
    
    init(size: CGFloat = 60) {
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(AppColors.success, lineWidth: 3)
                .frame(width: size, height: size)
                .scaleEffect(showRing ? 1.2 : 0.8)
                .opacity(showRing ? 0.0 : 1.0)
            
            Image(systemName: "checkmark")
                .font(.system(size: size * 0.4, weight: .bold))
                .foregroundColor(AppColors.success)
                .scaleEffect(showCheckmark ? 1.0 : 0.1)
                .opacity(showCheckmark ? 1.0 : 0.0)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.3)) {
                showCheckmark = true
            }
            
            withAnimation(.easeOut(duration: 0.6).delay(0.1)) {
                showRing = true
            }
        }
    }
}

struct FloatingParticle: View {
    @State private var offset: CGSize = .zero
    @State private var opacity: Double = 1.0
    let color: Color
    let size: CGFloat
    
    init(color: Color = AppColors.accent, size: CGFloat = 4) {
        self.color = color
        self.size = size
    }
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: size, height: size)
            .offset(offset)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: 2.0)) {
                    offset = CGSize(
                        width: Double.random(in: -50...50),
                        height: Double.random(in: -100...(-20))
                    )
                    opacity = 0.0
                }
            }
    }
}

struct ParticleBurst: View {
    @State private var animate = false
    let particleCount: Int
    let colors: [Color]
    
    init(particleCount: Int = 8, colors: [Color] = [AppColors.accent, AppColors.primary, AppColors.secondary]) {
        self.particleCount = particleCount
        self.colors = colors
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<particleCount, id: \.self) { index in
                FloatingParticle(
                    color: colors[index % colors.count],
                    size: CGFloat.random(in: 3...6)
                )
                .rotationEffect(.degrees(Double(index) * (360.0 / Double(particleCount))))
            }
        }
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        PixelLoadingView()
        
        PixelSuccessView()
        
        ParticleBurst()
            .frame(width: 100, height: 100)
    }
    .padding()
    .background(AppColors.backgroundGradient)
}
