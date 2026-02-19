import SwiftUI

struct SplashScreenView: View {
    @State private var isLoading = true
    @State private var rotation = 0.0
    @State private var scale = 0.8
    @State private var opacity = 0.0
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 2)
                        .frame(width: 120, height: 120)
                        .scaleEffect(scale)
                        .opacity(opacity)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [ColorManager.lightBlue, ColorManager.orange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotation))
                    
                    Circle()
                        .fill(ColorManager.orange)
                        .frame(width: 12, height: 12)
                        .scaleEffect(scale)
                }
                
                Spacer()
                
                Text("Loading...")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorManager.secondaryText)
                    .opacity(opacity)
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isLoading = false
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 0.8)) {
            opacity = 1.0
            scale = 1.0
        }
        
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
            rotation = 360
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            scale = 1.2
        }
    }
}

#Preview {
    SplashScreenView()
}
