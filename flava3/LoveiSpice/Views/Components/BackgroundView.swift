import SwiftUI

struct BackgroundView: View {
    @State private var pulseAnimation: CGFloat = 0
    
    var body: some View {
        ZStack {
            AppColors.enhancedBackground
                .ignoresSafeArea()
            
            AppColors.secondaryGradient
                .ignoresSafeArea()
                .opacity(0.6)
            
            AnimatedGradientOverlay(pulseAnimation: pulseAnimation)
                .ignoresSafeArea()
            
            StaticStarsView()
                .ignoresSafeArea()
        }
    }
}

struct StaticStarsView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    HStack {
                        Circle().fill(Color.white).frame(width: 2).opacity(0.8)
                        Spacer()
                        Circle().fill(Color.white).frame(width: 1.5).opacity(0.6)
                        Spacer()
                        Circle().fill(Color.white).frame(width: 2.5).opacity(0.9)
                    }
                    Spacer()
                    HStack {
                        Circle().fill(Color.white).frame(width: 1).opacity(0.5)
                        Spacer()
                        Circle().fill(Color.white).frame(width: 2).opacity(0.7)
                        Spacer()
                        Circle().fill(Color.white).frame(width: 1.5).opacity(0.6)
                    }
                    Spacer()
                    HStack {
                        Circle().fill(Color.white).frame(width: 2).opacity(0.8)
                        Spacer()
                        Circle().fill(Color.white).frame(width: 1).opacity(0.4)
                        Spacer()
                        Circle().fill(Color.white).frame(width: 2.5).opacity(0.9)
                    }
                }
                .padding()
            }
        }
    }
}

struct AnimatedGradientOverlay: View {
    let pulseAnimation: CGFloat
    
    var body: some View {
        LinearGradient(
            colors: [
                Color.accentPurple.opacity(0.15),
                Color.accentBlue.opacity(0.1),
                Color.accentTeal.opacity(0.12)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .opacity(0.5 + pulseAnimation * 0.3)
    }
}


#Preview {
    BackgroundView()
}
