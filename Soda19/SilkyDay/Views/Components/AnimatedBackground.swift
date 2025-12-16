import SwiftUI

struct AnimatedBackground: View {
    @State private var animateGradient = false
    @State private var floatingElements: [FloatingElement] = []
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    AppColors.primaryBlue,
                    AppColors.lightBlue,
                    AppColors.darkBlue,
                    AppColors.primaryBlue
                ]),
                startPoint: animateGradient ? .topLeading : .bottomTrailing,
                endPoint: animateGradient ? .bottomTrailing : .topLeading
            )
            .onAppear {
                withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
                generateFloatingElements()
            }
            
            ForEach(floatingElements) { element in
                FloatingElementView(element: element)
            }
        }
        .ignoresSafeArea()
    }
    
    private func generateFloatingElements() {
        floatingElements = (0..<15).map { _ in
            FloatingElement(
                id: UUID(),
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                y: CGFloat.random(in: 0...UIScreen.main.bounds.height),
                size: CGFloat.random(in: 20...60),
                opacity: Double.random(in: 0.1...0.4),
                animationDuration: Double.random(in: 3...8)
            )
        }
    }
}

struct FloatingElement: Identifiable {
    let id: UUID
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let opacity: Double
    let animationDuration: Double
}

struct FloatingElementView: View {
    let element: FloatingElement
    @State private var offset = CGSize.zero
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Circle()
            .fill(AppColors.floatingElement)
            .frame(width: element.size, height: element.size)
            .opacity(element.opacity)
            .scaleEffect(scale)
            .offset(offset)
            .position(x: element.x, y: element.y)
            .onAppear {
                startAnimation()
            }
    }
    
    private func startAnimation() {
        withAnimation(.easeInOut(duration: element.animationDuration).repeatForever(autoreverses: true)) {
            offset = CGSize(
                width: CGFloat.random(in: -50...50),
                height: CGFloat.random(in: -50...50)
            )
        }
        
        withAnimation(.easeInOut(duration: element.animationDuration * 0.7).repeatForever(autoreverses: true)) {
            scale = CGFloat.random(in: 0.8...1.2)
        }
    }
}

#Preview {
    AnimatedBackground()
}
