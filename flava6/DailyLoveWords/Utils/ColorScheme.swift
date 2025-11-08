import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0) 
    static let darkBlue = Color(red: 0.1, green: 0.3, blue: 0.8)
    static let lightBlue = Color(red: 0.7, green: 0.9, blue: 1.0)
    
    static let backgroundWhite = Color.white
    static let backgroundGray = Color(red: 0.98, green: 0.98, blue: 0.98)
    
    static let primaryText = Color(red: 0.1, green: 0.3, blue: 0.8)
    static let secondaryText = Color(red: 0.4, green: 0.4, blue: 0.4)
    static let accentText = Color(red: 0.2, green: 0.6, blue: 1.0)
    
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    
    static let pixelPink = Color(red: 1.0, green: 0.4, blue: 0.7)
    static let pixelYellow = Color(red: 1.0, green: 0.9, blue: 0.2)
    static let pixelPurple = Color(red: 0.6, green: 0.4, blue: 1.0)
    
    static let blueGradient = LinearGradient(
        gradient: Gradient(colors: [lightBlue, primaryBlue]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let whiteBlueGradient = LinearGradient(
        gradient: Gradient(colors: [backgroundWhite, lightBlue.opacity(0.3)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct FloatingBubble: View {
    @State private var moveUp = false
    @State private var moveRight = false
    
    let size: CGFloat
    let color: Color
    let duration: Double
    
    var body: some View {
        Circle()
            .fill(color.opacity(0.3))
            .frame(width: size, height: size)
            .offset(
                x: moveRight ? 100 : -100,
                y: moveUp ? -200 : 200
            )
            .animation(
                Animation.easeInOut(duration: duration)
                    .repeatForever(autoreverses: true),
                value: moveUp
            )
            .onAppear {
                moveUp.toggle()
                moveRight.toggle()
            }
    }
}

struct AnimatedBackground: View {
    var body: some View {
        ZStack {
            AppColors.whiteBlueGradient
                .ignoresSafeArea()
            
            ForEach(0..<6, id: \.self) { index in
                FloatingBubble(
                    size: CGFloat.random(in: 20...60),
                    color: [AppColors.primaryBlue, AppColors.lightBlue, AppColors.pixelPink].randomElement() ?? AppColors.primaryBlue,
                    duration: Double.random(in: 3...8)
                )
                .position(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                )
            }
        }
    }
}

struct PixelButton: View {
    let title: String
    let action: () -> Void
    let color: Color
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(FontManager.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 0)
                        .fill(color)
                        .overlay(
                            RoundedRectangle(cornerRadius: 0)
                                .stroke(color.opacity(0.8), lineWidth: 2)
                        )
                )
        }
        .scaleEffect(1.0)
        .animation(.easeInOut(duration: 0.1), value: false)
    }
}

struct PixelCard: View {
    let content: AnyView
    
    init<Content: View>(@ViewBuilder content: () -> Content) {
        self.content = AnyView(content())
    }
    
    var body: some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 0)
                    .fill(AppColors.backgroundWhite)
                    .shadow(color: AppColors.primaryBlue.opacity(0.2), radius: 8, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(AppColors.lightBlue, lineWidth: 1)
                    )
            )
    }
}
